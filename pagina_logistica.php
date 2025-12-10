<?php
session_start();
if ($_SESSION['usuario']['perfil'] != 'logistica') { header("Location: login.php"); exit; }
?>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Logística</title>
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Quicksand'; background: #111; color: #ddd; padding: 40px; }
        .painel { display: flex; gap: 20px; }
        .box { background: #222; padding: 20px; border-left: 5px solid #d42426; width: 200px; }
        h1 { color: #d42426; }
    </style>
</head>
<body>
    <h1>🚚 Painel de Logística</h1>
    <div class="painel">
        <div class="box">
            <h3>Entregas Hoje</h3>
            <h1>12</h1>
        </div>
        <div class="box" style="border-color: #F0B700;">
            <h3>Em Rota</h3>
            <h1>4</h1>
        </div>
        <div class="box" style="border-color: #165B33;">
            <h3>Caminhões Livres</h3>
            <h1>2</h1>
        </div>
    </div>
    <br><a href="login.php" style="color:white">Sair</a>
</body>
</html>
