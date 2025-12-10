<?php
session_start();
require 'conexao.php';

// Verifica se é cliente (usuario)
if (!isset($_SESSION['usuario_perfil']) || $_SESSION['usuario_perfil'] != 'usuario') {
    header("Location: login.php");
    exit;
}

// Pega os picolés do banco
$sql = "SELECT * FROM picoles";
$resultado = $conn->query($sql);
?>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Área do Cliente</title>
    <style>
        body { background: #0C141F; color: white; font-family: sans-serif; text-align: center; }
        .grid { display: flex; flex-wrap: wrap; justify-content: center; gap: 20px; padding: 20px; }
        .card { background: rgba(255,255,255,0.1); padding: 20px; border-radius: 10px; width: 200px; border: 1px solid #444; }
        .preco { color: #F0B700; font-weight: bold; font-size: 1.2em; }
    </style>
</head>
<body>
    <h1>🎄 Sabores Disponíveis</h1>
    <p>Olá, <?php echo $_SESSION['usuario_nome']; ?>! <a href="login.php" style="color:#F0B700">Sair</a></p>

    <div class="grid">
        <?php if($resultado->num_rows > 0): ?>
            <?php while($row = $resultado->fetch_assoc()): ?>
            <div class="card">
                <h3><?php echo $row['sabor']; ?></h3>
                <p><?php echo $row['descricao']; ?></p>
                <p class="preco">R$ <?php echo number_format($row['preco'], 2, ',', '.'); ?></p>
                <button>Comprar</button>
            </div>
            <?php endwhile; ?>
        <?php else: ?>
            <p>Nenhum picolé disponível no momento. A produção está trabalhando!</p>
        <?php endif; ?>
    </div>
</body>
</html>
