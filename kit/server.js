const http = require("http");
const WebSocket = require("ws");
const crypto = require("crypto");

const PORT =
  process.env.PORT || 3000;

const server =
  http.createServer((req, res) => {

    res.writeHead(200, {
      "Content-Type":
        "text/plain; charset=utf-8"
    });

    res.end(
      "QuickDrop signaling server is running."
    );

  });

const wss =
  new WebSocket.Server({
    server
  });

const rooms =
  new Map();


function randomRoom(){

  let room;

  do{

    room =
      Math.floor(
        100000 +
        Math.random() * 900000
      ).toString();

  }while(
    rooms.has(room)
  );

  return room;
}


function send(ws, data){

  if(
    ws &&
    ws.readyState ===
      WebSocket.OPEN
  ){

    ws.send(
      JSON.stringify(data)
    );

  }

}


wss.on(
  "connection",
  ws => {

    ws.id =
      crypto.randomUUID();

    ws.room = null;
    ws.role = null;


    send(ws, {
      type:"connected"
    });


    ws.on(
      "message",
      raw => {

        let msg;

        try{

          msg =
            JSON.parse(
              raw.toString()
            );

        }catch{

          send(ws, {
            type:"error",
            message:"Invalid message."
          });

          return;

        }


        /* =====================
           CREATE ROOM
        ===================== */

        if(
          msg.type ===
          "create-room"
        ){

          if(ws.room){

            send(ws, {
              type:"error",
              message:
                "Already in a room."
            });

            return;

          }


          const room =
            randomRoom();


          rooms.set(
            room,
            {
              host:ws,
              guest:null
            }
          );


          ws.room =
            room;

          ws.role =
            "host";


          send(ws, {

            type:
              "room-created",

            room

          });


          return;

        }


        /* =====================
           JOIN ROOM
        ===================== */

        if(
          msg.type ===
          "join-room"
        ){

          const room =
            String(
              msg.room || ""
            );


          const data =
            rooms.get(room);


          if(!data){

            send(ws, {

              type:"error",

              message:
                "Room not found."

            });

            return;

          }


          if(
            data.guest
          ){

            send(ws, {

              type:"error",

              message:
                "Room is full."

            });

            return;

          }


          data.guest =
            ws;


          ws.room =
            room;

          ws.role =
            "guest";


          send(ws, {

            type:
              "joined-room",

            room

          });


          send(
            data.host,
            {
              type:
                "peer-joined"
            }
          );


          return;

        }


        /* =====================
           RELAY SIGNAL
        ===================== */

        if(
          [
            "offer",
            "answer",
            "candidate"
          ].includes(
            msg.type
          )
        ){

          const room =
            rooms.get(
              ws.room
            );


          if(!room){

            send(ws, {

              type:"error",

              message:
                "Room no longer exists."

            });

            return;

          }


          const target =
            ws.role === "host"
              ? room.guest
              : room.host;


          if(!target){

            send(ws, {

              type:"error",

              message:
                "Other device is not connected."

            });

            return;

          }


          send(
            target,
            {
              type:
                msg.type,

              data:
                msg.data
            }
          );


          return;

        }

      }
    );


    /* =====================
       DISCONNECT
    ===================== */

    ws.on(
      "close",
      () => {

        const room =
          rooms.get(
            ws.room
          );


        if(!room)
          return;


        const other =
          ws.role === "host"
            ? room.guest
            : room.host;


        if(other){

          send(
            other,
            {
              type:
                "peer-left"
            }
          );

        }


        rooms.delete(
          ws.room
        );

      }
    );

  }
);


server.listen(
  PORT,
  () => {

    console.log(
      `QuickDrop signaling server running on port ${PORT}`
    );

  }
);
