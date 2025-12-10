-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 05/12/2025 às 17:58
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `fabrica_picoles`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `cadastro`
--

CREATE TABLE `cadastro` (
  `id` int(11) NOT NULL,
  `sabores` varchar(200) NOT NULL,
  `ingredientes` varchar(200) NOT NULL,
  `tipo_embalagem` varchar(300) NOT NULL,
  `aditivos_nutritivos` varchar(300) NOT NULL,
  `conservantes` varchar(300) NOT NULL,
  `revendedores` varchar(300) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `cadastros`
--

CREATE TABLE `cadastros` (
  `id` int(11) NOT NULL,
  `nome` varchar(200) NOT NULL DEFAULT 'Usuário',
  `email` varchar(200) NOT NULL,
  `senha` varchar(255) NOT NULL,
  `tipodecolaborador` enum('equipeCadastro','LiderLogistica','ChefeProducao','Administrador','ClientePadrao') NOT NULL DEFAULT 'usuario_producao',
  `ativo` tinyint(1) DEFAULT 1,
  `data_cadastro` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `cadastros`
--

INSERT INTO `cadastros` (`id`, `nome`, `email`, `senha`, `tipodecolaborador`, `ativo`, `data_cadastro`) VALUES
(1, 'EquipeCadastro', 'cadastro@fabricapicoles.com', 'cadastro123', 'cadastro', 1, '2025-12-05 16:44:27'),
(2, 'LiderLogistica', 'logistica@fabricapicoles.com', 'logistica23', 'logistica', 1, '2025-12-05 16:44:27'),
(3, 'ChefeProduçao', 'producao@fabricapicoles.com', 'producao34', 'producao', 1, '2025-12-05 16:44:27'),
(4, 'Administrador', 'admin@fabricapicoles.com', 'admin45', 'admin', 1, '2025-12-05 16:44:27');
(5, 'ClientePadrao', 'usuario@fabricapicoles.com', 'usuario67', 'usuario', 1, '2025-12-05 16:44:27');
-- --------------------------------------------------------

--
-- Estrutura para tabela `clientes`
--

CREATE TABLE `clientes` (
  `id` int(11) NOT NULL,
  `nome` varchar(200) NOT NULL,
  `cpf_cnpj` varchar(20) DEFAULT NULL,
  `contato` varchar(200) DEFAULT NULL,
  `endereco` text DEFAULT NULL,
  `data_cadastro` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `clientes`
--

INSERT INTO `clientes` (`id`, `nome`, `cpf_cnpj`, `contato`, `endereco`, `data_cadastro`) VALUES
(1, 'Supermercado Central', '12.345.678/0001-90', '(11) 98765-4321', 'Rua Principal, 100 - Centro', '2025-12-05 16:44:27'),
(2, 'Padaria Doce Sabor', '98.765.432/0001-21', 'padaria@email.com', 'Av. das Flores, 250 - Jardim', '2025-12-05 16:44:27'),
(3, 'Lanchonete Express', '111.222.333/0001-44', '(11) 99999-8888', 'Praça da Estação, 50 - Centro', '2025-12-05 16:44:27');

-- --------------------------------------------------------

--
-- Estrutura para tabela `estoque`
--

CREATE TABLE `estoque` (
  `id` int(11) NOT NULL,
  `picole_id` int(11) NOT NULL,
  `quantidade` int(11) NOT NULL DEFAULT 0,
  `data_validade` date DEFAULT NULL,
  `localizacao` varchar(100) DEFAULT NULL,
  `temperatura_ideal` decimal(5,2) DEFAULT -18.00,
  `ultima_atualizacao` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura stand-in para view `estoque_baixo`
-- (Veja abaixo para a visão atual)
--
CREATE TABLE `estoque_baixo` (
`id` int(11)
,`nome_sabor` varchar(200)
,`quantidade_total` decimal(32,0)
,`preco` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Estrutura para tabela `logs_acesso`
--

CREATE TABLE `logs_acesso` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `acao` varchar(100) NOT NULL,
  `descricao` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `data_hora` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `pedidos`
--

CREATE TABLE `pedidos` (
  `id` int(11) NOT NULL,
  `cliente_nome` varchar(200) NOT NULL,
  `picole_id` int(11) NOT NULL,
  `quantidade` int(11) NOT NULL,
  `endereco_entrega` text NOT NULL,
  `status` enum('pendente','em_rota','entregue','cancelado') DEFAULT 'pendente',
  `veiculo_id` int(11) DEFAULT NULL,
  `data_pedido` timestamp NOT NULL DEFAULT current_timestamp(),
  `data_entrega` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `picoles`
--

CREATE TABLE `picoles` (
  `id` int(11) NOT NULL,
  `nome_sabor` varchar(200) NOT NULL,
  `nome` varchar(200) DEFAULT NULL COMMENT 'Compatibilidade com salvar_picole.php',
  `preco` decimal(10,2) NOT NULL DEFAULT 0.00,
  `preco_venda` decimal(10,2) DEFAULT NULL COMMENT 'Preço de venda alternativo',
  `descricao` text DEFAULT NULL,
  `imagem` varchar(200) DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT 1,
  `data_cadastro` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `picoles`
--

INSERT INTO `picoles` (`id`, `nome_sabor`, `nome`, `preco`, `preco_venda`, `descricao`, `imagem`, `ativo`, `data_cadastro`) VALUES
(1, 'Picolé de Morango', 'Picolé de Morango', 3.50, NULL, 'Delicioso picolé sabor morango com pedaços de fruta', NULL, 1, '2025-12-05 16:44:27'),
(2, 'Picolé de Chocolate', 'Picolé de Chocolate', 4.00, NULL, 'Cremoso picolé de chocolate belga', NULL, 1, '2025-12-05 16:44:27'),
(3, 'Picolé de Limão', 'Picolé de Limão', 3.00, NULL, 'Refrescante picolé de limão siciliano', NULL, 1, '2025-12-05 16:44:27'),
(4, 'Picolé de Uva', 'Picolé de Uva', 3.50, NULL, 'Picolé sabor uva com suco natural', NULL, 1, '2025-12-05 16:44:27'),
(5, 'Picolé de Melancia', 'Picolé de Melancia', 3.50, NULL, 'Picolé refrescante sabor melancia', NULL, 1, '2025-12-05 16:44:27'),
(6, 'Picolé de Coco', 'Picolé de Coco', 4.50, NULL, 'Cremoso picolé de coco com leite condensado', NULL, 1, '2025-12-05 16:44:27'),
(7, '', 'marengo', 123.00, NULL, 'eeeeeeeeeeeeeeeeee', NULL, 1, '2025-12-05 16:46:18'),
(8, '', 'marengo', 123.00, NULL, 'eeeeeeeeeeeeeeeeee', NULL, 1, '2025-12-05 16:47:28');

-- --------------------------------------------------------

--
-- Estrutura para tabela `producao`
--

CREATE TABLE `producao` (
  `id` int(11) NOT NULL,
  `picole_id` int(11) NOT NULL,
  `quantidade` int(11) NOT NULL,
  `lote` varchar(50) NOT NULL,
  `responsavel` varchar(200) DEFAULT NULL,
  `data_producao` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Acionadores `producao`
--
DELIMITER $$
CREATE TRIGGER `atualizar_estoque_producao` AFTER INSERT ON `producao` FOR EACH ROW BEGIN
  IF EXISTS (SELECT 1 FROM estoque WHERE picole_id = NEW.picole_id LIMIT 1) THEN
    UPDATE estoque 
    SET quantidade = quantidade + NEW.quantidade,
        ultima_atualizacao = NOW()
    WHERE picole_id = NEW.picole_id;
  ELSE
    INSERT INTO estoque (picole_id, quantidade, temperatura_ideal)
    VALUES (NEW.picole_id, NEW.quantidade, -18.00);
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura stand-in para view `produtos_disponiveis`
-- (Veja abaixo para a visão atual)
--
CREATE TABLE `produtos_disponiveis` (
`id` int(11)
,`nome_sabor` varchar(200)
,`preco` decimal(10,2)
,`descricao` text
,`estoque_total` decimal(32,0)
,`ativo` tinyint(1)
);

-- --------------------------------------------------------

--
-- Estrutura para tabela `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nome` varchar(200) NOT NULL,
  `email` varchar(200) NOT NULL,
  `senha` varchar(255) NOT NULL,
  `perfil` enum('equipeCadastro','LiderLogistica','ChefeProducao','Administrador','ClientePadrao') NOT NULL DEFAULT 'cliente',
  `ativo` tinyint(1) DEFAULT 1,
  `data_cadastro` timestamp NOT NULL DEFAULT current_timestamp(),
  `ultimo_acesso` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `usuarios`
--

INSERT INTO `usuarios` (`id`, `nome`, `email`, `senha`, `perfil`, `ativo`, `data_cadastro`, `ultimo_acesso`) VALUES
(1, 'EquipeCadastro', 'cadastro@fabricapicoles.com', 'cadastro123', 'cadastro', 1, '2025-12-05 16:44:27'),
(2, 'LiderLogistica', 'logistica@fabricapicoles.com', 'logistica23', 'logistica', 1, '2025-12-05 16:44:27'),
(3, 'ChefeProduçao', 'producao@fabricapicoles.com', 'producao34', 'producao', 1, '2025-12-05 16:44:27'),
(4, 'Administrador', 'admin@fabricapicoles.com', 'admin45', 'admin', 1, '2025-12-05 16:44:27');
(5, 'ClientePadrao', 'usuario@fabricapicoles.com', 'usuario67', 'usuario', 1, '2025-12-05 16:44:27');
-- --------------------------------------------------------

--
-- Estrutura para tabela `veiculos`
--

CREATE TABLE `veiculos` (
  `id` int(11) NOT NULL,
  `placa` varchar(10) NOT NULL,
  `capacidade` int(11) NOT NULL,
  `temperatura_atual` decimal(5,2) DEFAULT -18.00,
  `status` enum('livre','em_rota','manutencao') DEFAULT 'livre'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `vendas`
--

CREATE TABLE `vendas` (
  `id` int(11) NOT NULL,
  `vendedor_id` int(11) NOT NULL,
  `cliente_nome` varchar(200) NOT NULL,
  `picole_id` int(11) NOT NULL,
  `quantidade` int(11) NOT NULL,
  `preco_unitario` decimal(10,2) NOT NULL,
  `valor_total` decimal(10,2) NOT NULL,
  `observacoes` text DEFAULT NULL,
  `emitir_nf` tinyint(1) DEFAULT 0,
  `data_venda` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Acionadores `vendas`
--
DELIMITER $$
CREATE TRIGGER `reduzir_estoque_venda` AFTER INSERT ON `vendas` FOR EACH ROW BEGIN
  UPDATE estoque 
  SET quantidade = GREATEST(0, quantidade - NEW.quantidade),
      ultima_atualizacao = NOW()
  WHERE picole_id = NEW.picole_id
  AND quantidade >= NEW.quantidade;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura stand-in para view `vendas_mes_atual`
-- (Veja abaixo para a visão atual)
--
CREATE TABLE `vendas_mes_atual` (
`id` int(11)
,`cliente_nome` varchar(200)
,`nome_sabor` varchar(200)
,`quantidade` int(11)
,`preco_unitario` decimal(10,2)
,`valor_total` decimal(10,2)
,`data_venda` timestamp
,`vendedor` varchar(200)
,`emitir_nf` tinyint(1)
);

-- --------------------------------------------------------

--
-- Estrutura para view `estoque_baixo`
--
DROP TABLE IF EXISTS `estoque_baixo`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `estoque_baixo`  AS SELECT `p`.`id` AS `id`, `p`.`nome_sabor` AS `nome_sabor`, coalesce(sum(`e`.`quantidade`),0) AS `quantidade_total`, `p`.`preco` AS `preco` FROM (`picoles` `p` left join `estoque` `e` on(`p`.`id` = `e`.`picole_id`)) WHERE `p`.`ativo` = 1 GROUP BY `p`.`id`, `p`.`nome_sabor`, `p`.`preco` HAVING `quantidade_total` < 50 ORDER BY coalesce(sum(`e`.`quantidade`),0) ASC ;

-- --------------------------------------------------------

--
-- Estrutura para view `produtos_disponiveis`
--
DROP TABLE IF EXISTS `produtos_disponiveis`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `produtos_disponiveis`  AS SELECT `p`.`id` AS `id`, `p`.`nome_sabor` AS `nome_sabor`, `p`.`preco` AS `preco`, `p`.`descricao` AS `descricao`, coalesce(sum(`e`.`quantidade`),0) AS `estoque_total`, `p`.`ativo` AS `ativo` FROM (`picoles` `p` left join `estoque` `e` on(`p`.`id` = `e`.`picole_id`)) WHERE `p`.`ativo` = 1 GROUP BY `p`.`id`, `p`.`nome_sabor`, `p`.`preco`, `p`.`descricao`, `p`.`ativo` ;

-- --------------------------------------------------------

--
-- Estrutura para view `vendas_mes_atual`
--
DROP TABLE IF EXISTS `vendas_mes_atual`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vendas_mes_atual`  AS SELECT `v`.`id` AS `id`, `v`.`cliente_nome` AS `cliente_nome`, `p`.`nome_sabor` AS `nome_sabor`, `v`.`quantidade` AS `quantidade`, `v`.`preco_unitario` AS `preco_unitario`, `v`.`valor_total` AS `valor_total`, `v`.`data_venda` AS `data_venda`, `u`.`nome` AS `vendedor`, `v`.`emitir_nf` AS `emitir_nf` FROM ((`vendas` `v` join `picoles` `p` on(`v`.`picole_id` = `p`.`id`)) join `usuarios` `u` on(`v`.`vendedor_id` = `u`.`id`)) WHERE month(`v`.`data_venda`) = month(curdate()) AND year(`v`.`data_venda`) = year(curdate()) ORDER BY `v`.`data_venda` DESC ;

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `cadastro`
--
ALTER TABLE `cadastro`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `cadastros`
--
ALTER TABLE `cadastros`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_email` (`email`),
  ADD KEY `idx_tipodecolaborador` (`tipodecolaborador`);

--
-- Índices de tabela `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cpf_cnpj` (`cpf_cnpj`),
  ADD KEY `idx_nome` (`nome`);

--
-- Índices de tabela `estoque`
--
ALTER TABLE `estoque`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_picole` (`picole_id`),
  ADD KEY `idx_validade` (`data_validade`);

--
-- Índices de tabela `logs_acesso`
--
ALTER TABLE `logs_acesso`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_usuario` (`usuario_id`),
  ADD KEY `idx_data` (`data_hora`);

--
-- Índices de tabela `pedidos`
--
ALTER TABLE `pedidos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_picole` (`picole_id`),
  ADD KEY `idx_veiculo` (`veiculo_id`),
  ADD KEY `idx_status` (`status`);

--
-- Índices de tabela `picoles`
--
ALTER TABLE `picoles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_ativo` (`ativo`),
  ADD KEY `idx_nome_sabor` (`nome_sabor`);

--
-- Índices de tabela `producao`
--
ALTER TABLE `producao`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_picole_id` (`picole_id`),
  ADD KEY `idx_lote` (`lote`),
  ADD KEY `idx_data` (`data_producao`);

--
-- Índices de tabela `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_email` (`email`),
  ADD KEY `idx_perfil` (`perfil`),
  ADD KEY `idx_ativo` (`ativo`);


-- Índices de tabela `vendas`
--
ALTER TABLE `vendas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_vendedor` (`vendedor_id`),
  ADD KEY `idx_picole` (`picole_id`),
  ADD KEY `idx_data` (`data_venda`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `cadastro`
--
ALTER TABLE `cadastro`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `cadastros`
--
ALTER TABLE `cadastros`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `estoque`
--
ALTER TABLE `estoque`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `logs_acesso`
--
ALTER TABLE `logs_acesso`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `pedidos`
--
ALTER TABLE `pedidos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `picoles`
--
ALTER TABLE `picoles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de tabela `producao`
--
ALTER TABLE `producao`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `veiculos`
--
ALTER TABLE `veiculos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `vendas`
--
ALTER TABLE `vendas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `estoque`
--
ALTER TABLE `estoque`
  ADD CONSTRAINT `fk_estoque_picole` FOREIGN KEY (`picole_id`) REFERENCES `picoles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `logs_acesso`
--
ALTER TABLE `logs_acesso`
  ADD CONSTRAINT `fk_logs_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `pedidos`
--
ALTER TABLE `pedidos`
  ADD CONSTRAINT `fk_pedidos_picole` FOREIGN KEY (`picole_id`) REFERENCES `picoles` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pedidos_veiculo` FOREIGN KEY (`veiculo_id`) REFERENCES `veiculos` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Restrições para tabelas `producao`
--
ALTER TABLE `producao`
  ADD CONSTRAINT `fk_producao_picole` FOREIGN KEY (`picole_id`) REFERENCES `picoles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `vendas`
--
ALTER TABLE `vendas`
  ADD CONSTRAINT `fk_vendas_picole` FOREIGN KEY (`picole_id`) REFERENCES `picoles` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_vendas_vendedor` FOREIGN KEY (`vendedor_id`) REFERENCES `usuarios` (`id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
