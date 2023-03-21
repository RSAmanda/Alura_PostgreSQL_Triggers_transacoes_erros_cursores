-- Aula postgresql - triggers, transações, erros e cursores
-- aula 1
-- a aula se inicia no projeto da ultima aula do curso de aula PL/pgSQL

CREATE TABLE aluno (
	id SERIAL PRIMARY KEY,
	primeiro_nome VARCHAR(255) NOT NULL,
	ultimo_nome VARCHAR(255) NOT NULL,
	data_nascimento DATE NOT NULL
);

CREATE TABLE categoria (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE curso(
	id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	categoria_id INTEGER NOT NULL REFERENCES categoria(id)
);

CREATE TABLE aluno_curso(
	aluno_id INTEGER NOT NULL REFERENCES aluno(id),
	curso_id INTEGER NOT NULL REFERENCES curso(id),
	PRIMARY KEY (aluno_id, curso_id)
);
-- cria curso
CREATE FUNCTION cria_curso(nome_curso VARCHAR, nome_categoria VARCHAR) RETURNS void AS $$
	DECLARE
		id_categoria INTEGER;
	BEGIN
		SELECT id INTO id_categoria FROM categoria WHERE nome=nome_categoria;
		IF NOT FOUND THEN
			INSERT INTO categoria (nome) VALUES (nome_categoria) RETURNING id INTO id_categoria;
		END IF;
		INSERT INTO curso (nome, categoria_id) VALUES (nome_curso, id_categoria);
	END;
$$ LANGUAGE plpgsql;

-- inserindo cursos
-- a função cria o curso e a categoria (caso ela não exista)
SELECT cria_curso('PHP', 'Programação');
SELECT cria_curso('Java', 'Programação');

SELECT * FROM curso;
SELECT * FROM categoria;

/*
	inserindo instrutores (com salários).
	se o salário for maior do que a média, salvar um log
	salvar outro log dizendo que fulano recebe mais do que x% da grade de instrutores
*/

CREATE TABLE log_instrutores(
	id SERIAL PRIMARY KEY,
	informacao VARCHAR(255),
	momento_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP	
);
/*
CREATE OR REPLACE FUNCTION cria_instrutor() RETURNS TRIGGER AS $$
	DECLARE
		media_salarial DECIMAL;
		instrutores_recebem_menos INTEGER DEFAULT 0;
		total_instrutores INTEGER DEFAULT 0;
		salario DECIMAL;
		percentual DECIMAL (5,2);
	BEGIN
		SELECT AVG(instrutor.salario) INTO media_salarial FROM instrutor WHERE id <> NEW.id;
		IF NEW.salario > media_salarial THEN
			INSERT INTO log_instrutores (informacao) VALUES (NEW.nome || ' recebe acima da média');
			RETURN NULL;
		END IF;
		
		FOR salario IN SELECT instrutor.salario FROM instrutor WHERE id <> NEW.id LOOP
			total_instrutores := total_instrutores +1;

			IF NEW.salario > salario THEN
				instrutores_recebem_menos := instrutores_recebem_menos + 1;
			END IF;
		END LOOP;
		percentual = instrutores_recebem_menos::DECIMAL / total_instrutores:: DECIMAL * 100;
		INSERT INTO log_instrutores (informacao)
			VALUES(NEW.nome || ' recebe mais do que ' || percentual || '% da grade de instrutores.');

		RETURN NEW;
	EXCEPTION
		WHEN undefined_column THEN
		RAISE NOTICE 'Algo de errado não está certo.';
		RAISE EXCEPTION 'Erro complicado de resolver';
	END;
$$ LANGUAGE plpgsql; */
-- criando um trigger que será executado depois de inserir um dado na tabela instrutor
CREATE TRIGGER cria_log_instrutores AFTER INSERT ON instrutor
	FOR EACH ROW EXECUTE FUNCTION cria_instrutor();
-- DROP TRIGGER:
-- DROP TRIGGER cria_log_instrutores ON instrutor;

SELECT * FROM instrutor;
SELECT * FROM log_instrutores;
BEGIN;
INSERT INTO instrutor (nome, salario) VALUES ('Marilia', 500); 
ROLLBACK;

-- Aula 03
DROP TRIGGER cria_log_instrutores ON instrutor;

CREATE TRIGGER cria_log_instrutores BEFORE INSERT ON instrutor
	FOR EACH ROW EXECUTE FUNCTION cria_instrutor();
	
CREATE OR REPLACE FUNCTION cria_instrutor() RETURNS TRIGGER AS $$
	DECLARE
		media_salarial DECIMAL;
		instrutores_recebem_menos INTEGER DEFAULT 0;
		total_instrutores INTEGER DEFAULT 0;
		salario DECIMAL;
		percentual DECIMAL (5,2);
		cursor_salarios refcursor;
	BEGIN
		SELECT AVG(instrutor.salario) INTO media_salarial FROM instrutor WHERE id <> NEW.id;
		IF NEW.salario > media_salarial THEN
			INSERT INTO log_instrutores (informacao) VALUES (NEW.nome || ' recebe acima da média');
			RETURN NULL;
		END IF;
		
		SELECT instrutores_internos(NEW.id) INTO cursor_salarios;
		LOOP
			FETCH cursor_salarios INTO salario;
			EXIT WHEN NOT FOUND;
			total_instrutores := total_instrutores +1;

			IF NEW.salario > salario THEN
				instrutores_recebem_menos := instrutores_recebem_menos + 1;
			END IF;
		END LOOP;
		percentual = instrutores_recebem_menos::DECIMAL / total_instrutores:: DECIMAL * 100;
		ASSERT percentual < 100::DECIMAL, 'Instrutores novos não podem receber mais que todos os antigos';
		
		INSERT INTO log_instrutores (informacao)
			VALUES(NEW.nome || ' recebe mais do que ' || percentual || '% da grade de instrutores.');

		RETURN NEW;

	END;
$$ LANGUAGE plpgsql; 

INSERT INTO instrutor (nome, salario) VALUES ('Marilia E', 500003); 
SELECT * FROM instrutor;
SELECT * FROM log_instrutores;

CREATE FUNCTION instrutores_internos(id_instrutor INTEGER) RETURNS refcursor AS $$
	DECLARE
		cursor_salarios refcursor;
	BEGIN
		OPEN cursor_salarios  FOR SELECT instrutor.salario
								   FROM instrutor
								  WHERE id <> id_instrutor
								    AND salario > 0;
	RETURN cursor_salarios;
	END;

$$ LANGUAGE plpgsql;