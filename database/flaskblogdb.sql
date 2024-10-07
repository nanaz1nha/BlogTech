-- Apaga o Banco de Dados se ele existir.
DROP DATABASE IF EXISTS flaskblogdb;

-- Recria o Banco de Dados
CREATE DATABASE flaskblogdb
-- Usando a tabela de caracteres universal extendida
	CHARACTER SET utf8mb4
-- Buscas também em utf8 e case insensitive
	COLLATE utf8mb4_general_ci;
    
-- Seleciona o Banco de Dados para os próximos comandos 
USE flaskblogdb;

-- Cria a tabela 'staff' conforme o modelo lógico
CREATE TABLE staff(
	-- Define o id como chave primária
	emp_id INT PRIMARY KEY AUTO_INCREMENT, 
    -- Define a data com valor do sistema
    emp_date TIMESTAMP DEFAULT current_timestamp,
    -- Define o nome do usuário com 127 caracteres
    emp_name VARCHAR(127) NOT NULL,
    -- Define o email do usuário com 255 caracteres (RFC)
    emp_email VARCHAR(255) NOT NULL,
    -- Define a senha do usuário com 63 caracteres
    emp_password VARCHAR(63) NOT NULL,
    -- Define a imagem do usuário com 255 caracteres
    emp_image VARCHAR(255),
    -- Data em formato ISO / System Date
    emp_birth DATE NOT NULL, 
    -- Define a descrição do usuário com 255 caracteres
    emp_description VARCHAR(255),
    -- Define lista com a opção 'moderator' como padrão
    emp_type ENUM('admin', 'author', 'moderator') 
    DEFAULT 'moderator',
    -- Define lista com a opção 'on' como padrão
    emp_status ENUM('on', 'off', 'del') DEFAULT 'on'
);

-- Cria a tabela 'article' conforme o modelo lógico
CREATE TABLE article(
	art_id INT PRIMARY KEY AUTO_INCREMENT, 
    art_date TIMESTAMP DEFAULT current_timestamp,
    art_author INT NOT NULL, 
    art_title VARCHAR(127) NOT NULL,
    art_resume VARCHAR(255) NOT NULL,
    art_thumbnail VARCHAR(255) NOT NULL,
    art_content TEXT NOT NULL,
	art_views INT NOT NULL DEFAULT 0,
	art_status ENUM('on', 'off', 'del')  DEFAULT 'on',
    FOREIGN KEY (art_author) REFERENCES staff (emp_id)
);

-- Cria a tabela 'comment' conforme o modelo lógico
CREATE TABLE comment(
	com_id INT PRIMARY KEY AUTO_INCREMENT, 
    com_date TIMESTAMP DEFAULT current_timestamp,
    com_article INT NOT NULL,
    com_author_name VARCHAR(127) NOT NULL, 
    com_author_email VARCHAR(255) NOT NULL,
    com_comment TEXT,
	com_status ENUM('on', 'off', 'del')  DEFAULT 'on',
    FOREIGN KEY (com_article) REFERENCES article (art_id)
);

-- Cria a tabela 'contact' conforme o modelo lógico
CREATE TABLE contact(
id INT PRIMARY KEY AUTO_INCREMENT,
date  TIMESTAMP DEFAULT current_timestamp,
name VARCHAR(127) NOT NULL,
email VARCHAR(255) NOT NULL,
subject VARCHAR(255) NOT NULL,
messsage TEXT,
status ENUM('on', 'off', 'del') DEFAULT 'on'
);

-- -------------------------------- --
-- Populando tabelas com dados fake --
-- -------------------------------- --
-- Insere dados na tabela 'staff'
-- Tabela "staff" --
INSERT INTO staff (
	emp_name,
    emp_email,
    emp_password,
    emp_image,
    emp_birth,
    emp_description
) VALUES (
    'Joca da Silva',
    'jocasilva@gmail.com',
    SHA1('Senha123'),
    'https://randomuser.me/api/portraits/men/2.jpg',
    '2000-05-28',
    'programador, escultor, pescador e enrolador'
),(
    'Marineusa Silva',
    'marineusa2000@gmail.com',
    SHA1('Senha123'),
    'https://randomuser.me/api/portraits/women/36.jpg',
    '1997-12-18',
    'Programadora, psicóloga, cantora e controladora'
),(
    'Setembrino Trocatapas',
    'setembrinobolado@gmail.com',
    SHA1('Senha123'),
    'https://randomuser.me/api/portraits/men/37.jpg',
    '1987-11-18',
    'Programador e destruidor de computador'
),(
    'Edicleuza Sarvastania',
    'edisarva@gmail.com',
    SHA1('Senha123'),
    'https://randomuser.me/api/portraits/women/16.jpg',
    '1980-10-12',
    'Programadora, organizadora e comentadora'
),(
    'João da Silva',
    'joaosilva@gmail.com',
    SHA1('Senha456'),
    'https://randomuser.me/api/portraits/men/1.jpg',
    '1990-05-15',
    'Engenheiro de Software'
),(
    'Maria Oliveira',
    'mariaoliveira@gmail.com',
    SHA1('Senha789'),
    'https://randomuser.me/api/portraits/women/2.jpg',
    '1985-08-22',
    'Designer Gráfica'
),(
    'Carlos Pereira',
    'carlospereira@gmail.com',
    SHA1('Senha321'),
    'https://randomuser.me/api/portraits/men/3.jpg',
    '1978-11-30',
    'Analista de Sistemas'
),(
    'Ana Costa',
    'anacosta@gmail.com',
    SHA1('Senha654'),
    'https://randomuser.me/api/portraits/women/4.jpg',
    '1992-03-10',
    'Gerente de Projetos'
),(
    'Pedro Souza',
    'pedrosouza@gmail.com',
    SHA1('Senha987'),
    'https://randomuser.me/api/portraits/men/5.jpg',
    '1983-07-25',
    'Desenvolvedor Web'
);

-- atualiza o type do staff --
UPDATE `flaskblogdb`.`staff` SET `emp_type` = 'author' WHERE (`emp_id` = '4');
UPDATE `flaskblogdb`.`staff` SET `emp_type` = 'author' WHERE (`emp_id` = '5');
UPDATE `flaskblogdb`.`staff` SET `emp_type` = 'author' WHERE (`emp_id` = '6');
UPDATE `flaskblogdb`.`staff` SET `emp_type` = 'admin' WHERE (`emp_id` = '1');
UPDATE `flaskblogdb`.`staff` SET `emp_type` = 'admin' WHERE (`emp_id` = '2');
UPDATE `flaskblogdb`.`staff` SET `emp_type` = 'author' WHERE (`emp_id` = '3');
UPDATE `flaskblogdb`.`staff` SET `emp_type` = 'author' WHERE (`emp_id` = '7');
UPDATE `flaskblogdb`.`staff` SET `emp_type` = 'author' WHERE (`emp_id` = '8');
UPDATE `flaskblogdb`.`staff` SET `emp_type` = 'author' WHERE (`emp_id` = '9');

SELECT * FROM staff;
SELECT * FROM staff WHERE emp_id = '5';
SELECT * FROM staff WHERE emp_name = 'Ana Costa';
-- troque entre 'DESC' e 'ASC' para testar a ordem entre descrescente ou crescente ----
SELECT * FROM staff ORDER BY emp_name ASC;

-- somente 'author' ----
SELECT emp_id, emp_name, emp_email 
FROM staff 
WHERE emp_type =  'author' 
ORDER BY emp_name;
-- tabela "article" --
INSERT INTO article (
art_author,
art_title,
art_resume,
art_thumbnail,
art_content
) VALUES (
	-- 'emp_id' de um staff existente --
    '2',
    'primeiro artigo',
    -- deixe os mesmos valores para todos os outros artigos --
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
    'https://fastly.picsum.photos/id/780/300/300.jpg?hmac=iJtQfncFYV4v9uaQNbwRTKfI_eJdYIH0Y5Wul-mKAyE',
    '<p>Lorem ipsum dolor sit, amet consectetur adipisicing elit. Voluptate id deleniti modi harum placeat ipsa atque nihil. Dolorem dicta facere, ex est, in necessitatibus officiis voluptate quasi delectus, vero quia.

</p>
<p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Illo explicabo repellat vitae laborum porro, eveniet harum ut, ab eligendi eaque dolor aperiam. Id dolore numquam ut nostrum quia, nisi eum.

</p>
<img src="https://fastly.picsum.photos/id/1067/500/500.jpg?hmac=34pP6bV4xWgaFHXjGboN40F9Gy8esUbPYL78s78eAt0" alt="imagem aleatória">
<p>Lorem ipsum, dolor sit amet consectetur adipisicing elit. Vel facilis, expedita nostrum, sint quas culpa commodi pariatur quos voluptate nobis dicta minus, dignissimos optio maiores animi harum placeat neque id.

</p>
<h4>Links:</h4>
<ul>
    <li><a href="http://catabit.com.br"> Site do Fesso</a></li>
    <li><a href="http://catabit.com.br">Git hub</a></li>
</ul>
<P>Lorem ipsum dolor sit amet consectetur adipisicing elit. Aliquam voluptas, autem harum tempore aut dolore veritatis eum iste, consequuntur maiores maxime illum, placeat itaque aspernatur. Hic explicabo exercitationem distinctio commodi!</P>'
),
(
	-- 'emp_id' de um staff existente --
    '3',
    'segundo artigo',
    -- deixe os mesmos valores para todos os outros artigos --
    'Lorem ipsum dolor sit amet',
    'https://fastly.picsum.photos/id/966/200/200.jpg?hmac=RmCTCEjm_X8xE8OAxo2-eCKM4eJu4LGQu-8U6Y3OmEM',
    '<p>Lorem ipsum dolor sit, amet consectetur adipisicing elit. Voluptate id deleniti modi harum placeat ipsa atque nihil. Dolorem dicta facere, ex est, in necessitatibus officiis voluptate quasi delectus, vero quia.

</p>
<p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Illo explicabo repellat vitae laborum porro, eveniet harum ut, ab eligendi eaque dolor aperiam. Id dolore numquam ut nostrum quia, nisi eum.

</p>
<img src="https://fastly.picsum.photos/id/1067/500/500.jpg?hmac=34pP6bV4xWgaFHXjGboN40F9Gy8esUbPYL78s78eAt0" alt="imagem aleatória">
<p>Lorem ipsum, dolor sit amet consectetur adipisicing elit. Vel facilis, expedita nostrum, sint quas culpa commodi pariatur quos voluptate nobis dicta minus, dignissimos optio maiores animi harum placeat neque id.

</p>
<h4>Links:</h4>
<ul>
    <li><a href="http://catabit.com.br"> Site do Fesso</a></li>
    <li><a href="http://catabit.com.br">Git hub</a></li>
</ul>
<P>Lorem ipsum dolor sit amet consectetur adipisicing elit. Aliquam voluptas, autem harum tempore aut dolore veritatis eum iste, consequuntur maiores maxime illum, placeat itaque aspernatur. Hic explicabo exercitationem distinctio commodi!</P>'
),
(
	-- 'emp_id' de um staff existente --
    '4',
    'terceiro artigo',
    -- deixe os mesmos valores para todos os outros artigos --
    'Lorem ipsum dolor sit amet abebe holahu',
    'https://fastly.picsum.photos/id/966/200/200.jpg?hmac=RmCTCEjm_X8xE8OAxo2-eCKM4eJu4LGQu-8U6Y3OmEM',
    '<p>Lorem ipsum dolor sit, amet consectetur adipisicing elit. Voluptate id deleniti modi harum placeat ipsa atque nihil. Dolorem dicta facere, ex est, in necessitatibus officiis voluptate quasi delectus, vero quia.

</p>
<p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Illo explicabo repellat vitae laborum porro, eveniet harum ut, ab eligendi eaque dolor aperiam. Id dolore numquam ut nostrum quia, nisi eum.

</p>
<img src="https://fastly.picsum.photos/id/1067/500/500.jpg?hmac=34pP6bV4xWgaFHXjGboN40F9Gy8esUbPYL78s78eAt0" alt="imagem aleatória">
<p>Lorem ipsum, dolor sit amet consectetur adipisicing elit. Vel facilis, expedita nostrum, sint quas culpa commodi pariatur quos voluptate nobis dicta minus, dignissimos optio maiores animi harum placeat neque id.

</p>
<h4>Links:</h4>
<ul>
    <li><a href="http://catabit.com.br"> Site do Fesso</a></li>
    <li><a href="http://catabit.com.br">Git hub</a></li>
</ul>
<P>Lorem ipsum dolor sit amet consectetur adipisicing elit. Aliquam voluptas, autem harum tempore aut dolore veritatis eum iste, consequuntur maiores maxime illum, placeat itaque aspernatur. Hic explicabo exercitationem distinctio commodi!</P>'
),
(
	-- 'emp_id' de um staff existente --
    '1',
    'quarto artigo',
    -- deixe os mesmos valores para todos os outros artigos --
    'Lorem ipsum dolor sit amet meteor',
    'https://fastly.picsum.photos/id/966/200/200.jpg?hmac=RmCTCEjm_X8xE8OAxo2-eCKM4eJu4LGQu-8U6Y3OmEM',
    '<p>Lorem ipsum dolor sit, amet consectetur adipisicing elit. Voluptate id deleniti modi harum placeat ipsa atque nihil. Dolorem dicta facere, ex est, in necessitatibus officiis voluptate quasi delectus, vero quia.

</p>
<p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Illo explicabo repellat vitae laborum porro, eveniet harum ut, ab eligendi eaque dolor aperiam. Id dolore numquam ut nostrum quia, nisi eum.

</p>
<img src="https://fastly.picsum.photos/id/1067/500/500.jpg?hmac=34pP6bV4xWgaFHXjGboN40F9Gy8esUbPYL78s78eAt0" alt="imagem aleatória">
<p>Lorem ipsum, dolor sit amet consectetur adipisicing elit. Vel facilis, expedita nostrum, sint quas culpa commodi pariatur quos voluptate nobis dicta minus, dignissimos optio maiores animi harum placeat neque id.

</p>
<h4>Links:</h4>
<ul>
    <li><a href="http://catabit.com.br"> Site do Fesso</a></li>
    <li><a href="http://catabit.com.br">Git hub</a></li>
</ul>
<P>Lorem ipsum dolor sit amet consectetur adipisicing elit. Aliquam voluptas, autem harum tempore aut dolore veritatis eum iste, consequuntur maiores maxime illum, placeat itaque aspernatur. Hic explicabo exercitationem distinctio commodi!</P>'
) ,
(
	-- 'emp_id' de um staff existente --
    '5',
    'quinto artigo',
    -- deixe os mesmos valores para todos os outros artigos --
    'Lorem ipsum dolor sit adisiping eliot',
    'https://fastly.picsum.photos/id/966/200/200.jpg?hmac=RmCTCEjm_X8xE8OAxo2-eCKM4eJu4LGQu-8U6Y3OmEM',
    '<p>Lorem ipsum dolor sit, amet consectetur adipisicing elit. Voluptate id deleniti modi harum placeat ipsa atque nihil. Dolorem dicta facere, ex est, in necessitatibus officiis voluptate quasi delectus, vero quia.

</p>
<p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Illo explicabo repellat vitae laborum porro, eveniet harum ut, ab eligendi eaque dolor aperiam. Id dolore numquam ut nostrum quia, nisi eum.

</p>
<img src="https://fastly.picsum.photos/id/1067/500/500.jpg?hmac=34pP6bV4xWgaFHXjGboN40F9Gy8esUbPYL78s78eAt0" alt="imagem aleatória">
<p>Lorem ipsum, dolor sit amet consectetur adipisicing elit. Vel facilis, expedita nostrum, sint quas culpa commodi pariatur quos voluptate nobis dicta minus, dignissimos optio maiores animi harum placeat neque id.

</p>
<h4>Links:</h4>
<ul>
    <li><a href="http://catabit.com.br"> Site do Fesso</a></li>
    <li><a href="http://catabit.com.br">Git hub</a></li>
</ul>
<P>Lorem ipsum dolor sit amet consectetur adipisicing elit. Aliquam voluptas, autem harum tempore aut dolore veritatis eum iste, consequuntur maiores maxime illum, placeat itaque aspernatur. Hic explicabo exercitationem distinctio commodi!</P>'
);
-- tabela comment ---
INSERT INTO comment(
-- Insira um "art_id" existente --
    com_article,
    com_author_name, 
    com_author_email,
    com_comment
	) VALUES (
    '5',
    'Marlinelson',
    'marlinelson@gmail.com',
    'É sobre isso!!'
    ), 
    (
    '4',
    'Marilia da Silva',
    'mariliasilva@gmail.com',
    'ficou muito bom, meus parabéns'
    ),
    (
    '3',
    'João Roberto',
    'robertinhos10@gmail.com',
    'ficou horrível, meus parabéns'
    ),
    (
    '1',
    'Cleyton Patrício',
    'cleytonrasta@gmail.com',
    'precisa melhorar!!!'
    ),
    (
    '2',
    'Adelaide Magalhães',
    'adelaideparaguaia@gmail.com',
    'Ficou ótimo!!!'
    );
    SELECT * FROM comment;











