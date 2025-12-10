<?php
// ARQUIVO: setup.php
$servidor = "localhost";
$usuario_db = "root";
$senha_db = "";

// 1. Conexão inicial para criar o banco
$conn = new mysqli($servidor, $usuario_db, $senha_db);
if ($conn->connect_error) die("Erro fatal: " . $conn->connect_error);

// Cria o banco e seleciona
$conn->query("CREATE DATABASE IF NOT EXISTS fabrica_picoles");
$conn->select_db("fabrica_picoles");

echo "<h2>🔧 Configurando Banco de Dados...</h2>";

// Desativa chaves estrangeiras para limpar tudo sem erros
$conn->query("SET FOREIGN_KEY_CHECKS = 0");

// Limpa tabelas antigas para evitar conflitos
$tabelas = ['usuarios', 'picoles']; 
foreach ($tabelas as $tabela) {
    $conn->query("DROP TABLE IF EXISTS $tabela");
}

// 2. Cria Tabela de Usuários
$sql_users = "CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    senha VARCHAR(255),
    perfil VARCHAR(50)
)";
$conn->query($sql_users);

// 3. Cria Tabela de Picolés (Unificada)
$sql_picoles = "CREATE TABLE picoles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sabor VARCHAR(100),
    descricao TEXT,
    preco DECIMAL(10,2),
    estoque INT DEFAULT 0
)";
$conn->query($sql_picoles);

// 4. Cria Usuários Padrão (COM SENHA CRIPTOGRAFADA)
$stmt = $conn->prepare("INSERT INTO usuarios (nome, email, senha, perfil) VALUES (?, ?, ?, ?)");

// Lista de usuários para criar: [Nome, Email, Senha, Perfil]
$lista = [
    ['Chefe Produção', 'producao@fabricapicoles.com', 'producao34', 'producao'],
    ['Logística',      'logistica@fabricapicoles.com', 'logistica23', 'logistica'],
    ['Cliente 01',     'usuario@fabricapicoles.com',  'usuario67',  'usuario']
];

foreach ($lista as $u) {
    // Cria o hash seguro da senha
    $hash = password_hash($u[2], PASSWORD_DEFAULT); 
    $stmt->bind_param("ssss", $u[0], $u[1], $hash, $u[3]);
    $stmt->execute();
    echo "<p>✅ Criado: <b>{$u[1]}</b> | Senha: <b>{$u[2]}</b> | Perfil: {$u[3]}</p>";
}

$conn->query("SET FOREIGN_KEY_CHECKS = 1");
echo "<h3>Tudo pronto! Vá para <a href='login.php'>login.php</a></h3>";
?>
