# Notas de Aula - PostgreSQL: Triggers, transações, erros e cursores

# Link do Curso

[Curso Online PostgreSQL: Triggers, transações, erros e cursores | Alura](https://cursos.alura.com.br/course/postgresql-triggers-transacoes-erros-cursores)

# Materiais de Apoio
   
    [CREATE TRIGGER](https://www.postgresql.org/docs/current/sql-createtrigger.html)
    
    [Dicas de Boas Práticas](https://www.alura.com.br/artigos/quanto-mais-simples-melhor)
    

# Aulas

## Triggers

*Triggers* são gatinhos que são acionados automaticamente em um evento.

Um *trigger* deve ser criado quando uma função precisar ser executada sempre que determinado evento ocorrer, por exemplo, sempre que um instrutor for inserido.

É permito retornar NULL.

Trigger que retorna nulo significa que a função não vai ser executada.

Um *trigger* não recebe parâmetro. Porém, há parâmetros exclusivos. Exemplos:

- NEW: Com a variável NEW, conseguimos acessar a linha que está sendo inserida no gatilho.
- OLD: Linha que está sendo removida ou alterada.

> Uma *Trigger Procedure* tem como seu retorno o tipo especial `TRIGGER`. Isso define que essa função vai ser usada em algum *trigger* e ativa algumas verificações do PostgreSQL.
> 

## Gerenciamento de Transações

- Não pode-se inserir transações em uma PL

> Uma PL já está por padrão dentro de uma transação. Se for chamada em um código SQL, ela fará parte da mesma transação que aquele código. Se for chamada automaticamente por um *trigger*, ela fará parte da transação da instrução que gerou esse *trigger*.
> 

Uma função não tem transação própria!

## Erros e Exceções

Podemos criar comandos para ser executado quando ocorre erro

Na criação da função, precisamos colocar

```sql
EXCEPTION
	WHEN ... THEN
		comandos;
```

Caso nós quiséssemos que apenas parte do código fosse “cancelado” no caso de um erro, poderíamos separar nossa função em diversos blocos.

Cada bloco pode tratar suas exceções de forma individual. Então se quiséssemos tratar a exceção do segundo `INSERT` e não cancelar a execução do primeiro, bastaria rodear esse segundo `INSERT`
 em um bloco `BEGIN - EXCEPTION - END`.

**Criando Mensagem de Erro:**

- Função RAISE

Para exibir a mensagem de erro, ela deverá ser inserida na parte EXCEPTION:

```sql
  EXCEPTION
		WHEN undefined_column THEN
		RAISE NOTICE 'Algo de errado não está certo.';
			RETURN NEW;-- ENCERROU A FUNÇÃO
	END;
```

**Verificar se uma condição é verdadeira:**

```sql
ASSERT condition [, message]:
```

## Cursores

Exemplo de como definir um cursor:

```sql
 DECLARE
    cursor_salarios refcursor;
  BEGIN
    OPEN cursos_salario  FOR SELECT instrutor.salario
                               FROM instrutor
                              WHERE id <> id_instrutor
                                AND salario > 0;

                    /* . . . */
  CLOSE cursor_salarios -- fecha o ponteiro
  END;
```

- Para usarmos um cursor, precisamos definir e depois abri-lo.
- Podemos nos mover de algumas formas dentro do cursor:
    
    ```sql
    -- FETCH : move o ponteiro e retorna o valor.
    FETCH LAST FROM cursor_salarios INTO salario;
    FETCH NEXT FROM cursor_salarios INTO salario;
    FETCH PRIOR FROM cursor_salarios INTO salario;
    FETCH FIRST FROM cursor_salarios INTO salario;
    
    -- MOVE : apenas move o ponteiro.
    MOVE LAST FROM cursor_salarios INTO salario;
    MOVE NEXT FROM cursor_salarios INTO salario;
    MOVE PRIOR FROM cursor_salarios INTO salario;
    MOVE FIRST FROM cursor_salarios INTO salario;
    
    ```
    

## Processos de Desenvolvimento

Bloco DO [bloco de código sem nome e sem retorno]

- Usado quando precisamos executar um script pontual;
- Para gerar relatórios;
- Para testar uma função;

Boas Práticas:

- padronizar nomes das variáveis;
- Evite o uso de ELSE;
    - Use o *early return;*
- Use *schemas* diferentes para módulos/contextos diferentes

Ferramentas utilizadas:

- pgAdmin;
- EMS SQL;
- DataGrip;
