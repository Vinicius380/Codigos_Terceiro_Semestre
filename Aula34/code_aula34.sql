CREATE DATABASE Loja;
USE Loja;

-- Nome do modelo OLAP os dados sao organizados em:
-- Fatos (Valores Numericos) e Dimensoes (Categorias para analise)
CREATE TABLE Dim_Categoria (
	CategoriaID INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(50)
);

-- Criar uma tabela de fatos
CREATE TABLE Fato_Vendas(
	VendaID INT PRIMARY KEY AUTO_INCREMENT,
    CategoriaID INT,
    Receita DECIMAL(10,2),
    Custo DECIMAL(10,2),
    Quantidade_Vendida INT,
    Data_Venda DATE,
    FOREIGN KEY (CategoriaID) REFERENCES Dim_Categoria(CategoriaID)
);

INSERT INTO Dim_Categoria (Nome) VALUES
('Eletronicos'), ('Moveis'), ('Roupas'), ('Alimentos'), ('Brinquedos'), ('Automoveis');


INSERT INTO Fato_Vendas (CategoriaID, Receita, Custo, Quantidade_Vendida, Data_Venda) VALUES
(1, 10000, 6000, 50, '2024-03-01'),
(2, 5000, 3000, 30, '2024-03-02'),
(3, 7000, 4000, 40, '2024-03-03'),
(4, 3000, 2000, 20, '2024-03-04'),
(5, 4000, 2500, 25, '2024-03-05'),
(6, 12000, 8000, 60, '2024-03-06');

SELECT c.Nome AS Categoria, v.Receita, v.Quantidade_Vendida
FROM Fato_Vendas v
JOIN Dim_Categoria c ON v.CategoriaID = c.CategoriaID;

-- MDX
-- SELECT
-- [Dim_Categoria].[Nome].MEMBERS ON ROWS,
-- [Measures].[Receita] ON COLUMNS
-- FROM [Cubo_Vendas]

SELECT c.Nome AS Categoria,
	v.Receita,
    v.Custo,
    (v.Receita - v.Custo) AS Lucro_Liquido
FROM Fato_Vendas v
JOIN Dim_Categoria c ON v.CategoriaID = c.CategoriaID;

-- MDX
-- WITH MEMBER [Measures].[Lucro_Liquido] AS ([Measures].[Receita] - [Measures].[Custo])
-- SELECT
-- [Dim_Categoria].[Nome].MEMBERS ON ROWS,
-- [Measures].[Lucro_Liquido] ON COLUMNS
-- FROM [Cubo_Vendas]

SELECT c.Nome AS Categoria,
	v.Receita,
    v.Custo,
    (v.Receita - v.Custo) AS Lucro_Liquido
FROM Fato_Vendas v
JOIN Dim_Categoria c ON v.CategoriaID = c.CategoriaID
ORDER BY Lucro_Liquido DESC;


-- MDX ITAUM
-- SELECT
-- ORDER ([Dim_Categoria].[Nome].MEMBERS, [Measures].[Lucro_Liquido], DESC) ON ROWS,
-- [Measures].[Lucro_Liquido] ON COLUMNS
-- FROM [Cubo_Vendas]