# Alura_PostgreSQL_Triggers_transacoes_erros_cursores
Repositório dos estudos relacionados ao curso 'PostgreSQL: Triggers, transações, erros e cursores' da Alura. O curso faz parte do Programa Desenvolve 2023 do Grupo Boticário.

# Notas de Aula
[Notas de Aula](https://github.com/RSAmanda/Alura_PostgreSQL_Triggers_transacoes_erros_cursores/blob/c5fcb9db6d5872f13eb581d9aa086923783897fb/Notas_de_Aula.md)

# Scripts
[Scripts das Aulas](https://github.com/RSAmanda/Alura_PostgreSQL_Triggers_transacoes_erros_cursores/blob/c5fcb9db6d5872f13eb581d9aa086923783897fb/postgresql_triggers_transacoes_erro_cursores_aulas.sql)

[Script Comando DO](https://github.com/RSAmanda/Alura_PostgreSQL_Triggers_transacoes_erros_cursores/blob/c5fcb9db6d5872f13eb581d9aa086923783897fb/postgresql_triggers_transacoes_erro_cursores_Comando_DO.sql)
# Conteúdo do Curso
## Triggers

- Entendemos o conceito de eventos no banco de dados
- Aprendemos como criar um *Trigger Procedure*
- Definimos um *Trigger* que executa uma *Trigger Procedure* quando um evento ocorre
- Entendemos a fundo detalhes de *triggers* como `FOR EACH ROW|STATEMENT`, etc

## Gerenciamento de Transações

- Vimos que há 2 sintaxes para iniciar uma transação: `BEGIN` e `START TRANSACTION`
- Entendemos que funções por si só já fazem parte de uma transação
- Aprendemos que erros cancelam as alterações de uma função

## Erros e Exceções

- Aprendemos o que são os erros (ou exceções) do PostgreSQL
- Aprendemos a gerar erros e mensagens com o `RAISE`
- Aprendemos a usar o `ASSERT` que verifica condições e levanta exceções
- Entendemos que o `RAISE` pode ser usado no processo de depuração

## Cursores

- Entendemos o propósito de usar cursores, para poupar uso de memória
- Vimos como abrir cursores, sendo eles *bound* ou *unbound*
- Vimos como manipular cursores com `FETCH` e `MOVE`
- Usamos cursores na prática em um `LOOP`

## Processos de Desenvolvimento

- Aprendemos a usar blocos anônimos com `DO`
- Vimos que blocos anônimos possuem 2 principais propósitos
    - Rodar um script pontual em PLpgSQL
    - Preparar uma função para efetivamente criá-la no futuro
- Entendemos que boas práticas de programação são muito importantes
- Conhecemos algumas outras ferramentas além do PgAdmin como DataGrip e EMS
