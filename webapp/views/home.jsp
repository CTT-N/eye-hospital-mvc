<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Eye Hospital</title>

    <style>

        body{
            font-family: Arial;
            margin:0;
            background:#f4f6f9;
        }

        /* top bar */

        .topbar{
            background:#0b6fa4;
            color:white;
            padding:8px 20px;
            display:flex;
            justify-content:space-between;
        }

        /* header */

        .header{
            background:white;
            padding:20px;
            display:flex;
            justify-content:space-between;
            align-items:center;
            border-bottom:1px solid #ddd;
        }

        .logo{
            font-size:24px;
            font-weight:bold;
            color:#0b6fa4;
        }

        .auth a{
            margin-left:15px;
            text-decoration:none;
            font-weight:bold;
        }

        .login{
            color:#0b6fa4;
        }

        .register{
            background:#0b6fa4;
            color:white;
            padding:6px 12px;
            border-radius:4px;
        }

        /* banner */

        .banner{
            height:300px;
            background:#cfe9f7;
            display:flex;
            align-items:center;
            justify-content:center;
            font-size:28px;
            font-weight:bold;
        }

        /* article grid */

        .container{
            width:90%;
            margin:auto;
            margin-top:40px;
        }

        .grid{
            display:grid;
            grid-template-columns:repeat(3,1fr);
            gap:20px;
        }

        .card{
            background:white;
            padding:20px;
            border-radius:6px;
            box-shadow:0 2px 5px rgba(0,0,0,0.1);
        }

        .card h3{
            color:#0b6fa4;
        }

        .footer{
            margin-top:50px;
            background:#333;
            color:white;
            text-align:center;
            padding:20px;
        }

    </style>

</head>

<body>

<!-- TOPBAR -->

<div class="topbar">

    <div>
        📍 123 Eye Hospital Street | ☎ 0900 123 456
    </div>

</div>


<!-- HEADER -->

<div class="header">

    <div class="logo">
        Eye Hospital
    </div>

    <div class="auth">

        <a class="login"
           href="${pageContext.request.contextPath}/auth/login">
            Login
        </a>

        <a class="register"
           href="#">
            Register
        </a>

    </div>

</div>


<!-- BANNER -->

<div class="banner">
    Eye Care Hospital Information
</div>


<!-- ARTICLES -->

<div class="container">

    <h2>Common Eye Diseases</h2>

    <div class="grid">

        <div class="card">
            <h3>Cataract</h3>
            <p>Information about cataract disease...</p>
        </div>

        <div class="card">
            <h3>Glaucoma</h3>
            <p>Information about glaucoma...</p>
        </div>

        <div class="card">
            <h3>Dry Eyes</h3>
            <p>Information about dry eyes...</p>
        </div>

        <div class="card">
            <h3>Macular Degeneration</h3>
            <p>Information about macular degeneration...</p>
        </div>

        <div class="card">
            <h3>Conjunctivitis</h3>
            <p>Information about conjunctivitis...</p>
        </div>

        <div class="card">
            <h3>Myopia</h3>
            <p>Information about myopia...</p>
        </div>

    </div>

</div>


<!-- FOOTER -->

<div class="footer">
    Eye Hospital © 2025
</div>


</body>
</html>