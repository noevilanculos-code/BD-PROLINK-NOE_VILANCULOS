-- ProLink v2 — consultas e testes para MySQL 8.0.16+
USE prolink;

-- Q1. Catálogo de programas com instituição, área e fonte de verificação.
SELECT p.id_programa,p.nome AS programa,p.nivel,p.duracao_meses,a.nome AS area,
       i.nome AS instituicao,p.estado_dado,p.url_fonte
FROM programa_estudo p JOIN instituicao i ON i.id_instituicao=p.id_instituicao
JOIN area_formacao a ON a.id_area=p.id_area
ORDER BY a.nome,p.nome;

-- Q2. Ver em que campus e modalidade um programa é leccionado.
SELECT p.nome,i.nome AS instituicao,c.nome AS campus,c.cidade,c.provincia,
       op.modalidade,op.turno,op.custo_matricula_mzn,op.custo_mensal_mzn,op.estado_dado
FROM oferta_programa op JOIN programa_estudo p ON p.id_programa=op.id_programa
JOIN campus c ON c.id_campus=op.id_campus JOIN instituicao i ON i.id_instituicao=c.id_instituicao
WHERE p.id_programa=1 ORDER BY c.cidade,op.modalidade;

-- Q3. Comparar custos e duração de ofertas de programas da área de Informática.
SELECT a.nome AS area,p.nome,c.cidade,op.modalidade,op.turno,
       COALESCE(op.duracao_meses,p.duracao_meses) AS duracao_meses,
       op.custo_matricula_mzn,op.custo_mensal_mzn
FROM oferta_programa op JOIN programa_estudo p ON p.id_programa=op.id_programa
JOIN area_formacao a ON a.id_area=p.id_area JOIN campus c ON c.id_campus=op.id_campus
WHERE p.id_area=1 ORDER BY op.custo_mensal_mzn;

-- Q4. Currículo completo, disciplinas e semestre (programa demonstrativo 1).
SELECT p.nome AS programa,pc.versao,ipc.ano_curricular,ipc.semestre,d.nome AS disciplina,
       ipc.creditos,ipc.carga_horaria,ipc.obrigatoria
FROM programa_estudo p JOIN plano_curricular pc ON pc.id_programa=p.id_programa
JOIN item_plano_curricular ipc ON ipc.id_plano=pc.id_plano
JOIN disciplina d ON d.id_disciplina=ipc.id_disciplina
WHERE p.id_programa=1 ORDER BY ipc.ano_curricular,ipc.semestre,ipc.numero_item;

-- Q5. Mostrar disciplinas com requisitos prévios.
SELECT d.nome AS disciplina,pr.nome AS disciplina_requisito,dp.tipo_requisito,dp.observacao
FROM disciplina_prerequisito dp JOIN disciplina d ON d.id_disciplina=dp.id_disciplina
JOIN disciplina pr ON pr.id_disciplina=dp.id_disciplina_requisito ORDER BY d.nome;

-- Q6. Ver quais vias do ensino secundário estão relacionadas com cada curso.
SELECT v.nome AS via_secundario,p.nome AS programa,p.nivel,pva.condicoes_acesso,pva.estado_dado
FROM programa_via_acesso pva JOIN via_ensino_secundario v ON v.id_via=pva.id_via
JOIN programa_estudo p ON p.id_programa=pva.id_programa ORDER BY v.nome,p.nome;

-- Q7. Carreiras e competências associadas a um programa.
SELECT p.nome AS programa,cp.nome AS carreira,co.nome AS competencia,cc.nivel_importancia
FROM programa_carreira pc JOIN programa_estudo p ON p.id_programa=pc.id_programa
JOIN carreira_profissional cp ON cp.id_carreira=pc.id_carreira
JOIN carreira_competencia cc ON cc.id_carreira=cp.id_carreira
JOIN competencia co ON co.id_competencia=cc.id_competencia ORDER BY p.nome,cp.nome,co.nome;

-- Q8. Explorar progressão académica de licenciatura para pós-graduação.
SELECT origem.nome AS programa_origem,destino.nome AS programa_destino,
       destino.nivel,pa.requisitos_resumo,pa.estado_dado
FROM percurso_academico pa JOIN programa_estudo destino ON destino.id_programa=pa.id_programa_destino
LEFT JOIN programa_estudo origem ON origem.id_programa=pa.id_programa_origem
WHERE pa.id_programa_origem IS NOT NULL ORDER BY origem.nome,destino.nivel;

-- Q9. Ciclos de admissão, vagas, campus e prazo. Os registos são demonstração.
SELECT ca.ano_lectivo,ca.nome_ciclo,ca.vagas,ca.data_abertura,ca.data_fecho,ca.estado,
       p.nome AS programa,i.nome AS instituicao,c.nome AS campus,c.cidade
FROM ciclo_admissao ca JOIN oferta_programa op ON op.id_oferta=ca.id_oferta
JOIN programa_estudo p ON p.id_programa=op.id_programa JOIN campus c ON c.id_campus=op.id_campus
JOIN instituicao i ON i.id_instituicao=c.id_instituicao ORDER BY ca.data_fecho;

-- Q10. Oportunidades abertas ou a verificar e a respectiva fonte.
SELECT o.titulo,o.tipo,o.localizacao,o.prazo_candidatura,o.estado_publicacao,
       f.nome AS fonte,o.url_fonte,o.estado_dado
FROM oportunidade o LEFT JOIN fonte_informacao f ON f.id_fonte=o.id_fonte
WHERE o.estado_publicacao IN ('ABERTA','A_VERIFICAR') ORDER BY o.prazo_candidatura;

-- Q11. Oportunidades relacionadas com programas e profissões.
SELECT o.titulo,o.tipo,p.nome AS programa,cp.nome AS carreira
FROM oportunidade o LEFT JOIN oportunidade_programa op ON op.id_oportunidade=o.id_oportunidade
LEFT JOIN programa_estudo p ON p.id_programa=op.id_programa
LEFT JOIN oportunidade_carreira oc ON oc.id_oportunidade=o.id_oportunidade
LEFT JOIN carreira_profissional cp ON cp.id_carreira=oc.id_carreira
ORDER BY o.titulo,p.nome,cp.nome;

-- Q12. Perfil e múltiplas áreas de interesse de um estudante.
SELECT u.nome,u.nivel_atual,u.provincia,a.nome AS area_interesse,uai.prioridade
FROM utilizador u JOIN utilizador_area_interesse uai ON uai.id_utilizador=u.id_utilizador
JOIN area_formacao a ON a.id_area=uai.id_area WHERE u.id_utilizador=1 ORDER BY uai.prioridade;

-- Q13. Histórico educativo de um utilizador.
SELECT u.nome,fu.nome_formacao,fu.nivel,fu.ano_inicio,fu.ano_fim,fu.estado,
       i.nome AS instituicao,p.nome AS programa
FROM formacao_utilizador fu JOIN utilizador u ON u.id_utilizador=fu.id_utilizador
LEFT JOIN instituicao i ON i.id_instituicao=fu.id_instituicao
LEFT JOIN programa_estudo p ON p.id_programa=fu.id_programa WHERE u.id_utilizador=4;

-- Q14. Ver programas guardados para comparação.
SELECT u.nome,p.nome AS programa,i.nome AS instituicao,pg.data_guardado,pg.nota_pessoal
FROM programa_guardado pg JOIN utilizador u ON u.id_utilizador=pg.id_utilizador
JOIN programa_estudo p ON p.id_programa=pg.id_programa JOIN instituicao i ON i.id_instituicao=p.id_instituicao
WHERE u.id_utilizador=1 ORDER BY pg.data_guardado;

-- Q15. Acompanhar candidaturas de admissão.
SELECT u.nome,p.nome AS programa,c.nome AS campus,ca.ano_lectivo,
       cad.estado,cad.data_criacao,cad.data_submissao,cad.numero_protocolo
FROM candidatura_admissao cad JOIN utilizador u ON u.id_utilizador=cad.id_utilizador
JOIN ciclo_admissao ca ON ca.id_ciclo=cad.id_ciclo JOIN oferta_programa op ON op.id_oferta=ca.id_oferta
JOIN programa_estudo p ON p.id_programa=op.id_programa JOIN campus c ON c.id_campus=op.id_campus
ORDER BY u.nome;

-- Q16. Candidaturas a bolsas, estágios, empregos e outras oportunidades.
SELECT u.nome,o.titulo,o.tipo,co.estado,co.data_criacao,co.data_submissao
FROM candidatura_oportunidade co JOIN utilizador u ON u.id_utilizador=co.id_utilizador
JOIN oportunidade o ON o.id_oportunidade=co.id_oportunidade ORDER BY co.data_criacao;

-- Q17. Plano pessoal e etapas do utilizador.
SELECT u.nome,pp.titulo,pp.estado AS estado_plano,ep.numero_etapa,ep.tipo_etapa,
       ep.descricao,ep.data_limite,ep.estado AS estado_etapa
FROM plano_pessoal pp JOIN utilizador u ON u.id_utilizador=pp.id_utilizador
JOIN etapa_plano ep ON ep.id_plano_pessoal=pp.id_plano_pessoal
WHERE u.id_utilizador=1 ORDER BY ep.numero_etapa;

-- Q18. Recomendações transparentes com pontuação e avisos.
SELECT sr.objetivo,sr.data_criacao,ir.posicao,p.nome AS programa,ir.pontuacao,
       ir.motivo,ir.pontos_a_confirmar
FROM sessao_recomendacao sr JOIN item_recomendacao ir ON ir.id_recomendacao=sr.id_recomendacao
JOIN programa_estudo p ON p.id_programa=ir.id_programa
WHERE sr.id_utilizador=1 ORDER BY sr.data_criacao DESC,ir.posicao;

-- Q19. Agregação: número de programas por área.
SELECT a.nome AS area,COUNT(p.id_programa) AS total_programas
FROM area_formacao a LEFT JOIN programa_estudo p ON p.id_area=a.id_area
GROUP BY a.id_area,a.nome ORDER BY total_programas DESC,a.nome;

-- Q20. Agregação: vagas demonstrativas por cidade.
SELECT c.cidade,SUM(ca.vagas) AS vagas_demo,COUNT(ca.id_ciclo) AS ciclos
FROM ciclo_admissao ca JOIN oferta_programa op ON op.id_oferta=ca.id_oferta
JOIN campus c ON c.id_campus=op.id_campus GROUP BY c.cidade ORDER BY vagas_demo DESC;

-- Q21. Subconsulta: ofertas cujo custo mensal está abaixo da média conhecida.
SELECT p.nome,c.cidade,op.modalidade,op.custo_mensal_mzn
FROM oferta_programa op JOIN programa_estudo p ON p.id_programa=op.id_programa
JOIN campus c ON c.id_campus=op.id_campus
WHERE op.custo_mensal_mzn < (SELECT AVG(custo_mensal_mzn) FROM oferta_programa WHERE custo_mensal_mzn IS NOT NULL)
ORDER BY op.custo_mensal_mzn;

-- Q22. Integridade: programas sem instituição, área ou origem registada correcta (deve dar zero).
SELECT COUNT(*) AS programas_sem_instituicao FROM programa_estudo p LEFT JOIN instituicao i ON i.id_instituicao=p.id_instituicao WHERE i.id_instituicao IS NULL;
SELECT COUNT(*) AS programas_sem_area FROM programa_estudo p LEFT JOIN area_formacao a ON a.id_area=p.id_area WHERE a.id_area IS NULL;

-- Q23. Integridade das entidades fracas: item curricular sem plano/disciplina (deve dar zero).
SELECT COUNT(*) AS itens_sem_plano FROM item_plano_curricular x LEFT JOIN plano_curricular p ON p.id_plano=x.id_plano WHERE p.id_plano IS NULL;
SELECT COUNT(*) AS itens_sem_disciplina FROM item_plano_curricular x LEFT JOIN disciplina d ON d.id_disciplina=x.id_disciplina WHERE d.id_disciplina IS NULL;

-- Q24. Auditoria de informação por verificar antes de publicar.
SELECT 'instituicao' AS tabela,COUNT(*) AS por_verificar FROM instituicao WHERE estado_verificacao<>'VERIFICADO'
UNION ALL SELECT 'programa_estudo',COUNT(*) FROM programa_estudo WHERE estado_dado<>'VERIFICADO'
UNION ALL SELECT 'plano_curricular',COUNT(*) FROM plano_curricular WHERE estado_dado<>'VERIFICADO'
UNION ALL SELECT 'ciclo_admissao',COUNT(*) FROM ciclo_admissao WHERE estado_dado<>'VERIFICADO'
UNION ALL SELECT 'oportunidade',COUNT(*) FROM oportunidade WHERE estado_dado<>'VERIFICADO';

-- Q25. UPDATE controlado: a transacção termina em ROLLBACK e preserva o exemplo.
START TRANSACTION;
UPDATE utilizador SET estado='INATIVO' WHERE id_utilizador=1;
SELECT id_utilizador,nome,estado FROM utilizador WHERE id_utilizador=1;
ROLLBACK;
SELECT id_utilizador,nome,estado FROM utilizador WHERE id_utilizador=1;

-- Q26. DELETE controlado: a transacção termina em ROLLBACK.
START TRANSACTION;
DELETE FROM etapa_plano WHERE id_plano_pessoal=20 AND numero_etapa=2;
SELECT * FROM etapa_plano WHERE id_plano_pessoal=20;
ROLLBACK;
SELECT * FROM etapa_plano WHERE id_plano_pessoal=20;

-- Q27. Teste de FK (comentado): deve falhar por instituição inexistente.
-- INSERT INTO programa_estudo (id_instituicao,id_area,nome,nivel,duracao_meses,descricao,requisitos_gerais,estado_dado)
-- VALUES (99999,1,'Programa inválido','LICENCIATURA',48,'Teste','Teste','DEMONSTRACAO');

-- Q28. Teste de chave composta da entidade fraca (comentado): o par repetido deve ser rejeitado.
-- INSERT INTO item_plano_curricular (id_plano,numero_item,id_disciplina,ano_curricular,semestre,carga_horaria)
-- VALUES (1,1,1,1,1,60);

-- Q29. Contagem de registos por tabela (requisito académico: mínimo 20 por tabela).
SELECT 'area_formacao' tabela,COUNT(*) total FROM area_formacao
UNION ALL SELECT 'fonte_informacao',COUNT(*) FROM fonte_informacao
UNION ALL SELECT 'instituicao',COUNT(*) FROM instituicao
UNION ALL SELECT 'campus',COUNT(*) FROM campus
UNION ALL SELECT 'via_ensino_secundario',COUNT(*) FROM via_ensino_secundario
UNION ALL SELECT 'utilizador',COUNT(*) FROM utilizador
UNION ALL SELECT 'programa_estudo',COUNT(*) FROM programa_estudo
UNION ALL SELECT 'oferta_programa',COUNT(*) FROM oferta_programa
UNION ALL SELECT 'programa_via_acesso',COUNT(*) FROM programa_via_acesso
UNION ALL SELECT 'disciplina',COUNT(*) FROM disciplina
UNION ALL SELECT 'plano_curricular',COUNT(*) FROM plano_curricular
UNION ALL SELECT 'item_plano_curricular',COUNT(*) FROM item_plano_curricular
UNION ALL SELECT 'disciplina_prerequisito',COUNT(*) FROM disciplina_prerequisito
UNION ALL SELECT 'carreira_profissional',COUNT(*) FROM carreira_profissional
UNION ALL SELECT 'competencia',COUNT(*) FROM competencia
UNION ALL SELECT 'carreira_competencia',COUNT(*) FROM carreira_competencia
UNION ALL SELECT 'programa_carreira',COUNT(*) FROM programa_carreira
UNION ALL SELECT 'percurso_academico',COUNT(*) FROM percurso_academico
UNION ALL SELECT 'ciclo_admissao',COUNT(*) FROM ciclo_admissao
UNION ALL SELECT 'oportunidade',COUNT(*) FROM oportunidade
UNION ALL SELECT 'oportunidade_programa',COUNT(*) FROM oportunidade_programa
UNION ALL SELECT 'oportunidade_carreira',COUNT(*) FROM oportunidade_carreira
UNION ALL SELECT 'utilizador_area_interesse',COUNT(*) FROM utilizador_area_interesse
UNION ALL SELECT 'formacao_utilizador',COUNT(*) FROM formacao_utilizador
UNION ALL SELECT 'programa_guardado',COUNT(*) FROM programa_guardado
UNION ALL SELECT 'oportunidade_guardada',COUNT(*) FROM oportunidade_guardada
UNION ALL SELECT 'candidatura_admissao',COUNT(*) FROM candidatura_admissao
UNION ALL SELECT 'candidatura_oportunidade',COUNT(*) FROM candidatura_oportunidade
UNION ALL SELECT 'plano_pessoal',COUNT(*) FROM plano_pessoal
UNION ALL SELECT 'etapa_plano',COUNT(*) FROM etapa_plano
UNION ALL SELECT 'sessao_recomendacao',COUNT(*) FROM sessao_recomendacao
UNION ALL SELECT 'item_recomendacao',COUNT(*) FROM item_recomendacao
UNION ALL SELECT 'notificacao',COUNT(*) FROM notificacao ORDER BY tabela;
