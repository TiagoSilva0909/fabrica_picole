<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Login - Fábrica de Natal</title>
    <style>
        body { font-family: sans-serif; background: #0C141F; color: white; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .box { background: rgba(255,255,255,0.1); padding: 40px; border-radius: 10px; text-align: center; border: 1px solid #444; }
        input { display: block; width: 100%; margin: 10px 0; padding: 10px; box-sizing: border-box; }
        button { background: #D42426; color: white; border: none; padding: 10px; width: 100%; cursor: pointer; font-weight: bold; }
        button:hover { background: #b01a1c; }
    </style>
</head>
<body>
    <div class="box">
        <h2>🎅 Acesso à Fábrica</h2>
        <form action="validar.php" method="POST">
            <input type="email" name="email" placeholder="Seu E-mail" required>
            <input type="password" name="senha" placeholder="Sua Senha" required>
            <button type="submit">Entrar</button>
        </form>
    </div>
</body>
</html>
