# Validação estrutural e limitações — ProLink v2

## Modelo
- 33 tabelas relacionais organizadas em módulos; quatro diagramas ER de detalhe e um mapa geral.
- Chaves estrangeiras, restrições `CHECK`, `UNIQUE` e chaves compostas documentadas no SQL.
- Entidades fracas demonstradas por `item_plano_curricular`, `etapa_plano` e `item_recomendacao`.
- O modelo distingue `programa_estudo` (curso/ciclo académico), `oferta_programa` (campus, modalidade, turno e custo) e `ciclo_admissao` (ano, vagas e prazos).
- A tabela `fonte_informacao` e os campos de verificação suportam rastreabilidade e controlo da qualidade dos dados.

## Contagem dos registos inseridos
- `area_formacao`: 20
- `fonte_informacao`: 20
- `instituicao`: 20
- `campus`: 25
- `via_ensino_secundario`: 20
- `utilizador`: 20
- `programa_estudo`: 25
- `oferta_programa`: 30
- `programa_via_acesso`: 30
- `disciplina`: 30
- `plano_curricular`: 25
- `item_plano_curricular`: 50
- `disciplina_prerequisito`: 20
- `carreira_profissional`: 24
- `competencia`: 24
- `carreira_competencia`: 72
- `programa_carreira`: 50
- `percurso_academico`: 25
- `ciclo_admissao`: 30
- `oportunidade`: 25
- `oportunidade_programa`: 30
- `oportunidade_carreira`: 30
- `utilizador_area_interesse`: 40
- `formacao_utilizador`: 20
- `programa_guardado`: 40
- `oportunidade_guardada`: 40
- `candidatura_admissao`: 20
- `candidatura_oportunidade`: 20
- `plano_pessoal`: 20
- `etapa_plano`: 40
- `sessao_recomendacao`: 20
- `item_recomendacao`: 40
- `notificacao`: 20

## Limitações
- Os registos são exemplos demonstrativos; a maioria não está ligada a URLs oficiais verificadas.
- A nomenclatura das vias A/B/C do ensino secundário é ilustrativa e deve ser substituída pela nomenclatura curricular aplicável e confirmada oficialmente.
- O script foi verificado estruturalmente por código, mas não executado num servidor MySQL nesta sessão; executar no MySQL Workbench antes da entrega.
- `senha_hash` fica NULL nos dados de demonstração. A aplicação futura deverá produzir hashes seguros no backend e implementar autorização; nunca usar palavra-passe em texto simples.
- A base de dados não substitui um processo de verificação editorial, nem assegura por si só o envio real de notificações.
- Relações entre programa, carreira e vias de acesso são demonstrações até confirmação documental.
