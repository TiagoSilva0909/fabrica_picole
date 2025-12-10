<?php
session_start();
require 'conexao.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email = $_POST['email'];
    $senha = $_POST['senha'];

    // Busca o usuário pelo email
    $stmt = $conn->prepare("SELECT id, nome, senha, perfil FROM usuarios WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $resultado = $stmt->get_result();

    if ($linha = $resultado->fetch_assoc()) {
        // Verifica se a senha bate com a criptografia
        if (password_verify($senha, $linha['senha'])) {
            
            $_SESSION['usuario_nome'] = $linha['nome'];
            $_SESSION['usuario_perfil'] = $linha['perfil'];

            // REDIRECIONAMENTO CORRETO
            switch ($linha['perfil']) {
                case 'producao':
                    header("Location: pagina_producao.php");
                    break;
                case 'logistica':
                    header("Location: pagina_logistica.php");
                    break;
                case 'usuario':
                    header("Location: pagina_cliente.php");
                    break;
                default:
                    header("Location: login.php");
            }
            exit;
        } else {
            echo "<script>alert('Senha incorreta!'); window.location='login.php';</script>";
        }
    } else {
        echo "<script>alert('E-mail não encontrado!'); window.location='login.php';</script>";
    }
}
?><?php
session_start();
require 'conexao.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email = $_POST['email'];
    $senha = $_POST['senha'];

    // Busca o usuário pelo email
    $stmt = $conn->prepare("SELECT id, nome, senha, perfil FROM usuarios WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $resultado = $stmt->get_result();

    if ($linha = $resultado->fetch_assoc()) {
        // Verifica se a senha bate com a criptografia
        if (password_verify($senha, $linha['senha'])) {
            
            $_SESSION['usuario_nome'] = $linha['nome'];
            $_SESSION['usuario_perfil'] = $linha['perfil'];

            // REDIRECIONAMENTO CORRETO
            switch ($linha['perfil']) {
                case 'producao':
                    header("Location: pagina_producao.php");
                    break;
                case 'logistica':
                    header("Location: pagina_logistica.php");
                    break;
                case 'usuario':
                    header("Location: pagina_cliente.php");
                    break;
                default:
                    header("Location: login.php");
            }
            exit;
        } else {
            echo "<script>alert('Senha incorreta!'); window.location='login.php';</script>";
        }
    } else {
        echo "<script>alert('E-mail não encontrado!'); window.location='login.php';</script>";
    }
}
?>
