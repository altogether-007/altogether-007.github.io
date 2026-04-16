<!DOCTYPE html>
<html lang="bn">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CashoutCharge.com - Calculator</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background-color: #f0f2f5;
            display: flex;
            justify-content: center;
            padding: 20px;
            margin: 0;
        }

        .container {
            width: 100%;
            max-width: 450px;
            background: #fff;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }

        h1 { 
            font-size: 22px; 
            color: #333; 
            text-align: center;
            border-bottom: 2px solid #333;
            padding-bottom: 10px;
            margin-top: 0;
            margin-bottom: 20px;
        }

        /* মেইন বক্সের রেডিয়াস চারদিকে সমান করা হয়েছে যেহেতু ট্যাব নেই */
        .main-box {
            background-color: #c5e1a5;
            padding: 25px 15px;
            border-radius: 12px;
            text-align: center;
        }

        input[type="number"] {
            width: 90%;
            padding: 15px;
            border-radius: 8px;
            border: 2px solid #81c784;
            font-size: 20px;
            text-align: center;
            outline: none;
            margin-bottom: 20px;
        }

        .result-table {
            width: 100%;
            background: white;
            border-collapse: collapse;
            border-radius: 8px;
            overflow: hidden;
        }

        .result-table th, .result-table td {
            padding: 12px;
            border-bottom: 1px solid #eee;
            text-align: left;
            font-size: 14px;
        }

        .result-table th { background: #333; color: white; }

        .charge-amt {
            font-weight: bold;
            color: #d32f2f;
            text-align: right;
        }

        .priyo-row {
            background-color: #fff0f5; 
        }

        .footer {
            font-size: 11px;
            color: #777;
            margin-top: 20px;
            line-height: 1.6;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>CashoutCharge.com</h1>

    <div class="main-box">
        <p style="margin: 0 0 10px 0; font-weight: bold; color: #2e7d32;">টাকার পরিমাণ লিখুন</p>
        <input type="number" id="amount" placeholder="0.00" oninput="calculate()">

        <table class="result-table">
            <thead>
                <tr>
                    <th>অপারেটর (App)</th>
                    <th style="text-align: right;">চার্জ (টাকা)</th>
                </tr>
            </thead>
            <tbody>
                <tr class="priyo-row">
                    <td>bKash (প্রিয় এজেন্ট ১.৪৯%)</td>
                    <td id="bkashPriyo" class="charge-amt">0.00</td>
                </tr>
                <tr>
                    <td>bKash (সাধারণ ১.৮৫%)</td>
                    <td id="bkash" class="charge-amt">0.00</td>
                </tr>
                <tr>
                    <td>Nagad (১.৪৯৯%)</td>
                    <td id="nagad" class="charge-amt">0.00</td>
                </tr>
                <tr>
                    <td>Rocket (১.৬৭%)</td>
                    <td id="rocket" class="charge-amt">0.00</td>
                </tr>
                <tr>
                    <td>Upay (১.৪০%)</td>
                    <td id="upay" class="charge-amt">0.00</td>
                </tr>
            </tbody>
        </table>
    </div>

    <div class="footer">
        <b>Disclaimer:</b> এই হিসাবটি শুধুমাত্র সাধারণ অ্যাপ ক্যাশআউট চার্জের উপর ভিত্তি করে তৈরি। অপারেটররা যেকোনো সময় চার্জ পরিবর্তন করতে পারে। সঠিক চার্জ জানতে সংশ্লিষ্ট অ্যাপ চেক করুন।
    </div>
</div>

<script>
    function calculate() {
        const amount = document.getElementById('amount').value;
        
        if (amount && amount > 0) {
            const rates = {
                bkashPriyo: 0.0149, 
                bkash: 0.0185,      
                nagad: 0.01499,     
                rocket: 0.0167,     
                upay: 0.0140        
            };

            document.getElementById('bkashPriyo').innerText = (amount * rates.bkashPriyo).toFixed(2);
            document.getElementById('bkash').innerText = (amount * rates.bkash).toFixed(2);
            document.getElementById('nagad').innerText = (amount * rates.nagad).toFixed(2);
            document.getElementById('rocket').innerText = (amount * rates.rocket).toFixed(2);
            document.getElementById('upay').innerText = (amount * rates.upay).toFixed(2);
        } else {
            document.getElementById('bkashPriyo').innerText = "0.00";
            document.getElementById('bkash').innerText = "0.00";
            document.getElementById('nagad').innerText = "0.00";
            document.getElementById('rocket').innerText = "0.00";
            document.getElementById('upay').innerText = "0.00";
        }
    }
</script>

</body>
</html>
