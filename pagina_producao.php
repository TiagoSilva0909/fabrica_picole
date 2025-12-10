<?php
session_start();
require 'conexao.php';

// Verifica se é da produção
if (!isset($_SESSION['usuario_perfil']) || $_SESSION['usuario_perfil'] != 'producao') {
    // header("Location: login.php");
    // exit;
}

$mensagem = "";

// PROCESSAR O FORMULÁRIO
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['acao']) && $_POST['acao'] == 'cadastrar') {
    // Dados do Picolé
    $sabor = $_POST['sabor'] ?? '';
    $preco = $_POST['preco'] ?? 0;
    $descricao = $_POST['descricao'] ?? '';
    
    // Dados da Produção
    $quantidade = $_POST['quantidade'] ?? 0;
    $lote = $_POST['lote'] ?? '';
    $responsavel = $_SESSION['usuario_nome'] ?? 'Produção';

    if (!empty($sabor) && !empty($preco) && !empty($quantidade)) {
        
        $conn->begin_transaction();

        try {
            // 1. Inserir na tabela 'picoles'
            // IMPORTANTE: Já definimos o 'estoque' inicial com a quantidade produzida
            $stmt1 = $conn->prepare("INSERT INTO picoles (sabor, preco, descricao, estoque) VALUES (?, ?, ?, ?)");
            $stmt1->bind_param("sdsi", $sabor, $preco, $descricao, $quantidade);
            
            if (!$stmt1->execute()) {
                throw new Exception("Erro ao cadastrar picolé: " . $stmt1->error);
            }
            
            $picole_id = $conn->insert_id;

            // 2. Inserir na tabela 'producao'
            // Certifique-se de ter rodado o SQL para criar as colunas 'lote' e 'responsavel'
            $stmt2 = $conn->prepare("INSERT INTO producao (picole_id, quantidade, lote, responsavel, data_producao) VALUES (?, ?, ?, ?, NOW())");
            $stmt2->bind_param("iiss", $picole_id, $quantidade, $lote, $responsavel);

            if (!$stmt2->execute()) {
                throw new Exception("Erro ao registrar produção: " . $stmt2->error);
            }

            $conn->commit();
            $mensagem = "<p style='color:green'>✅ Sabor <b>$sabor</b> cadastrado com estoque inicial de <b>$quantidade</b>!</p>";

        } catch (Exception $e) {
            $conn->rollback();
            // Verifica se o erro é sobre coluna faltando
            if (strpos($e->getMessage(), "Unknown column") !== false) {
                $mensagem = "<p style='color:red'>❌ Erro de Banco: Coluna não encontrada. Você rodou o comando SQL sugerido?</p>";
            } else {
                $mensagem = "<p style='color:red'>❌ " . $e->getMessage() . "</p>";
            }
        }

    } else {
        $mensagem = "<p style='color:red'>⚠️ Preencha Sabor, Preço e Quantidade.</p>";
    }
}

// LISTAGEM
// Removi 'data_criacao' do SELECT para evitar erro caso você não tenha criado a coluna ainda
$resultado = $conn->query("SELECT id, sabor, preco, descricao, estoque FROM picoles,producao ORDER BY id DESC");
?>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Produção Integrada</title>
    <link rel="stylesheet" href="style.css">
    <style>
        body { background:#0C141F; color:white; font-family:sans-serif; padding:20px; }
        .card { background:rgba(255,255,255,0.06); padding:18px; border-radius:8px; margin-bottom:18px; }
        ul { padding-left:20px; }
        li { margin-bottom: 8px; border-bottom: 1px solid #333; padding-bottom: 5px; }
        input, textarea { padding: 8px; margin: 5px 0; width: 100%; max-width: 400px; box-sizing: border-box; }
        button { padding: 10px 20px; background-color: #D42426; color: white; border: none; cursor: pointer; font-weight: bold; }
        label { font-weight: bold; display: block; margin-top: 10px; color: #F0B700; }
    </style>
</head>
<body>

<h1>🏭 Painel de Produção</h1>
<p>Logado como: <?php echo htmlspecialchars($_SESSION['usuario_nome'] ?? 'Visitante'); ?></p>

<?php if ($mensagem): ?>
    <div class="card"><?php echo $mensagem; ?></div>
<?php endif; ?>

<div class="card">
    <h3>Novo Produção</h3>
    <form method="POST" action="">
        <input type="hidden" name="acao" value="cadastrar">
        
        <label>Picolé:</label>
        <input type="text" name="sabor" placeholder="Sabor (ex: Chocolate)" required>
        <input type="number" step="0.01" name="preco" placeholder="Preço Venda (R$)" required>
        <textarea name="descricao" placeholder="Descrição" rows="1"></textarea>
        
        <label>Dados da Produção:</label>
        <input type="number" name="quantidade" placeholder="Qtd. Produzida" required>
        <input type="text" name="lote" placeholder="Lote (ex: 2023-A)" required>
        
        <br><br>
        <button type="submit">💾 Cadastrar e Produzir</button>
    </form>
</div>

<h3>Estoque Atual:</h3>
<ul>
<?php
if ($resultado && $resultado->num_rows > 0):
    while ($row = $resultado->fetch_assoc()):
?>
    <li>
        <strong><?php echo htmlspecialchars($row['sabor']); ?></strong> <br>
        <small>Preço: R$ <?php echo number_format($row['preco'], 2, ',', '.'); ?> | 
        Estoque: <?php echo $row['estoque']; ?> un.</small>
    </li>
<?php 
    endwhile; 
else:
?>
    <li>Nenhum picolé cadastrado.</li>
<?php endif; ?>
</ul>

</body>
</html>