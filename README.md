# ProLink — Trabalho II de Tecnologias de Bases de Dados (versão ampliada)

## Objectivo
Base de dados relacional para apoiar um assistente pessoal de educação e carreira: explorar cursos, comparar campus/modalidades/custos, compreender currículos, ligar formação a carreiras e pós-graduação, consultar ciclos de admissão e oportunidades, guardar opções e acompanhar candidaturas e planos pessoais.

## Conteúdo
- `01_criacao_e_dados.sql` — cria a base `prolink`, as 33 tabelas e dados demonstrativos.
- `02_consultas_e_testes.sql` — 29 blocos de consultas, agregações e testes.
- `03_diagrama_ER.png` / `.svg` — mapa geral de módulos, propositadamente simples.
- `03A_ER_catalogo_curriculo.png` / `.svg` — catálogo, campus, ofertas, vias de acesso e currículo.
- `03B_ER_percursos_carreiras.png` / `.svg` — percursos académicos, carreiras e competências.
- `03C_ER_admissoes_oportunidades.png` / `.svg` — ciclos de admissão, vagas, bolsas, estágios, emprego e candidaturas.
- `03D_ER_perfil_plano.png` / `.svg` — utilizador, perfil, recomendações, favoritos, plano e notificações.
- `03_diagrama_ER_completo.pdf` — conjunto imprimível dos diagramas.
- `Relatorio_Trabalho_II_ProLink.docx` / `.pdf` — relatório.
- `04_guiao_video_8-12min.md` — guião sugerido de apresentação.
- `05_checklist_entrega.md` — verificação antes da submissão.
- `VALIDACAO_E_LIMITACOES.md` — contagens e limitações conhecidas.

## Como executar
1. Faça cópia de segurança se já existir uma base `prolink`.
2. Abra MySQL Workbench e conecte-se ao MySQL 8.0.16 ou superior.
3. Abra e execute `01_criacao_e_dados.sql` por inteiro num ambiente de desenvolvimento/teste. **O script apaga e recria as tabelas.**
4. Abra `02_consultas_e_testes.sql` e execute os blocos em sequência; confira especialmente Q1-Q18 e Q29.
5. Não apresente os dados de demonstração como informação oficial, nem alegue que as vagas de exemplo são reais.

## Nota essencial de qualidade dos dados
Os dados de oferta, custos, currículos, áreas de acesso, vagas, bolsas, empregos e percursos são exclusivamente demonstrativos. A indicação de uma instituição real não valida os cursos associados. Antes da publicação real, cada registo necessita de fonte verificável, URL específica, data de revisão e processo editorial de actualização.

## Boas práticas para o futuro sistema web
- Nunca armazenar palavra-passe em texto simples; preencher `senha_hash` com hash seguro produzido pela aplicação.
- Não utilizar contas de exemplo em produção.
- Implementar autenticação/autorização no backend; as tabelas não substituem controlo de permissões.
- Revalidar prazos e vagas antes de os mostrar como actuais.
- Fazer backups, migrações versionadas e testes de integridade antes de cada actualização.


**Correção do import:** a inserção de `campus` foi ajustada para que as 11 colunas tenham 11 valores em cada registo. Use o script desta versão corrigida.

##LINK DO VIDEO DO YOUTUBE:
https://www.youtube.com/watch?v=MSzZ3oqqiHw&authuser=0
