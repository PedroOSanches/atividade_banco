-- Active: 1779975789762@@pi-gameficacao-db-pedrohenriqueoliveirasanches3-0b27.i.aivencloud.com@16095@jornadamauadb
-- ======================= Adicionar Usuario/Aluno ===================== --
INSERT INTO
    usuario (
        nome_usuario,
        sobrenome_usuario,
        username_usuario,
        senha_usuario,
        tipo_usuario
    )
VALUES (
        'Nome',
        'Sobrenome',
        'xx.xxxxx-x@maua.br',
        'Xxxxx12x@',
        'aluno'
    );

-- ======================== Adicionar Usuario/Professor =================== --
INSERT INTO
    usuario (
        nome_usuario,
        sobrenome_usuario,
        username_usuario,
        senha_usuario,
        tipo_usuario
    )
VALUES (
        'Nome',
        'Sobrenome',
        'nome.sobrenome@maua.br',
        'Xxxxx12x@',
        'professor'
    );

-- ======================== Login =================== --
SELECT senha_usuario FROM usuario WHERE username_usuario;
-- ====================== Cadastro Turma / Trasacao ====================== --

INSERT INTO ano (ano) VALUES (2026);

SET @ultimo_id_ano = LAST_INSERT_ID();

INSERT INTO
    semestre (semestre, id_ano)
VALUES ('primeiro', @ultimo_id_ano);

SET @ultimo_id_semestre = LAST_INSERT_ID();

INSERT INTO curso (nomecurso) VALUES ('Ciências da Computação');

SET @ultimo_id_curso = LAST_INSERT_ID();

INSERT INTO turma (cod_turma) VALUES ('T00');

SET @ultimo_id_turma = LAST_INSERT_ID();

INSERT INTO subturma (cod_subturma) VALUES ('SUB00');

SET @ultimo_id_subturma = LAST_INSERT_ID();

INSERT INTO
    turma_subturma (
        id_turma,
        id_subturma,
        id_curso,
        semestre_turma_subturma
    )
VALUES (
        @ultimo_id_turma,
        @ultimo_id_subturma,
        @ultimo_id_curso,
        @ultimo_id_semestre
    );

--- ===================== Inserção Usuario na Turma ================= ---
INSERT INTO
    turma_usuario (id_usuario, id_turma_subturma)
VALUES (1, 1);

-- ==================== Cadastro de Secao ===================== --
INSERT INTO
    secao (titulo_secao, descricao_secao)
VALUES ('Teste', 'Teste...');
-- =================== Cadastro Casa ========================= --
INSERT INTO
    casa (
        id_secao,
        titulo_casa,
        data_limite_casa
    )
VALUES (1, 'Teste', '2026-06-24');

-- ============ Cadastro de Tarefa / Transacao =============== --
BEGIN;

INSERT INTO
    tarefa (
        titulo_tarefa,
        id_casa,
        prazo_tarefa
    )
VALUES ('Teste', 1, '2026-06-15');

SET @id_tarefa_criada = LAST_INSERT_ID();

-- =============== Questao Alternativa ============ --
INSERT INTO
    questao (
        id_tarefa,
        tipo_questao,
        enunciado_questao
    )
VALUES (
        @id_tarefa_criada,
        'alternativa',
        'Teste...'
    );

SET @questao_alternativa_criada = LAST_INSERT_ID();

-- Repete com dependendo do numero de alternativas registradas.
INSERT INTO
    alternativa (
        id_questao,
        correta,
        texto_alternativa
    )
VALUES (
        @questao_alternativa_criada,
        0,
        'Teste...'
    );
---------------------------------------------------------------------------------------------------------------------------------------
-- =============== Questao Dissertativa ============ --
INSERT INTO
    questao (
        id_tarefa,
        tipo_questao,
        enunciado_questao
    )
VALUES (
        @id_tarefa_criada,
        'dissertativa',
        'Teste...'
    );

SET @questao_dissertativa_gerada = LAST_INSERT_ID();

INSERT INTO
    dissertativa (
        id_questao,
        resposta_modelo_dissertativa
    )
VALUES (
        @questao_dissertativa_gerada,
        'resposta modelo dissertativa'
    );
---------------------------------------------------------------------------------------------------------------------------------------
-- =============== Questao Upload ============ --
INSERT INTO
    questao (
        id_tarefa,
        tipo_questao,
        enunciado_questao
    )
VALUES (
        @id_tarefa_criada,
        'upload',
        'Teste...'
    );

SET @questao_upload_criada = LAST_INSERT_ID();

INSERT INTO
    upload (
        id_questao,
        arquivo_modelo_upload,
        titulo_upload
    )
VALUES (
        @questao_upload_criada,
        'TTT001_nomearquivo_upload.extencao',
        'Titulo_upload'
    );

COMMIT;


-- ============================== Transacao Registro de Tentativa Realizada ==============================
BEGIN;

INSERT INTO tentativa(
                      status_tentativa,
                      data_tentativa,
                      id_usuario,
                      id_tarefa
) VALUES ('concluida',
          '2026-06-05',
          1,
          1
         );
SET @tentativa_gerada = LAST_INSERT_ID();
SAVEPOINT tentativa;

INSERT INTO resposta(id_tentativa, id_questao) VALUES(@tentativa_gerada, 1);
SET @resposta_gerada = LAST_INSERT_ID();
SAVEPOINT resposta;

-- ============================== Resposta Alternativa ==============================
INSERT INTO resposta_alternativa(id_resposta, id_alternativa) VALUES(@resposta_gerada, 1);

-- ============================== Resposta Dissertativa ==============================
INSERT INTO resposta_dissertativa(
                                  id_resposta,
                                  resposta
) VALUES(
         @resposta_gerada,
         'Resposta Aluno'
        );
-- ============================== Resposta Upload ==============================
INSERT INTO resposta_upload(
                            id_resposta,
                            arquivo_resposta
) VALUES(
         @resposta_gerada, 'TTT01_nomeArquivo_nomeAluno.extensao'
        );

commit;

-- ============================== Registro Nova Secao do Tabuleiro ==============================
INSERT INTO secao(titulo_secao, descricao_secao) VALUES('Explorador', 'Descricao');

-- ============================== Registro Nova Casa ==============================
INSERT INTO casa(id_secao, titulo_casa, data_limite_casa) VALUES (1, 'Titulo Casa', '2026-06-05');

-- ============================== Select Progresso Aluno ==============================
SELECT 
    tarefas_concluidas,
    total_tarefas,
    ROUND(tarefas_concluidas * 100.0 / total_tarefas, 2) as progresso_aluno
FROM (
    SELECT 
        COUNT(DISTINCT id_tarefa) as tarefas_concluidas,
        (SELECT COUNT(*) FROM tarefa) as total_tarefas
    FROM tentativa
    WHERE id_usuario = 16
) resultado;

-- ============================== Select para Popular Tarefa do Aluno ==============================
SELECT
	id_tarefa,
	titulo_tarefa,
	prazo_tarefa,
	titulo_casa,
	data_limite_casa,
	titulo_secao,
	nome_curso
FROM turma_usuario
JOIN turma_subturma
	ON turma_usuario.id_turma_subturma = turma_subturma.id_turma_subturma
JOIN curso
	ON turma_subturma.id_curso = curso.id_curso
JOIN secao
	ON secao.id_secao = secao.id_secao
JOIN casa
	ON casa.id_secao = secao.id_secao
JOIN tarefa
	ON tarefa.id_casa = casa.id_casa
WHERE turma_usuario.id_usuario = 1
ORDER BY prazo_tarefa;

-- ============================== Select para Popular Corrige Tarefa ==============================
SELECT
	nome_usuario,
	sobrenome_usuario,
	id_tentativa,
	status_tentativa,
	data_tentativa,
	enunciado_questao,
	tipo_questao,
	id_resposta,
	nota_resposta,
	feedback_resposta
FROM tentativa
JOIN usuario
	ON tentativa.id_usuario = usuario.id_usuario
JOIN resposta
	ON resposta.id_tentativa = tentativa.id_tentativa
JOIN questao
	ON resposta.id_questao = questao.id_questao
WHERE tentativa.id_tarefa = 1
ORDER BY id_tentativa, id_questao;

-- ============================== Select para Popular Corrige Tarefa (Alternativa) ==============================
SELECT
	id_resposta,
	texto_alternativa,
	correta
FROM resposta
JOIN resposta_alternativa
	ON resposta_alternativa.id_resposta = resposta.id_resposta
JOIN alternativa
	ON resposta_alternativa.id_alternativa = alternativa.id_alternativa
WHERE resposta.id_tentativa = 1;

-- ============================== Select para Popular Corrige Tarefa (Dissertativa) ==============================
SELECT
	id_resposta,
	resposta AS texto_resposta_aluno,
	resposta_modelo_dissertativa
FROM resposta
JOIN resposta_dissertativa
	ON resposta_dissertativa.id_resposta = resposta.id_resposta
JOIN questao
	ON resposta.id_questao = questao.id_questao
JOIN dissertativa
	ON dissertativa.id_questao = questao.id_questao
WHERE resposta.id_tentativa = 1;

-- ============================== Select para Popular Corrige Tarefa (Upload) ==============================
SELECT
	id_resposta,
	arquivo_resposta,
	titulo_upload,
	arquivo_modelo_upload
FROM resposta
JOIN resposta_upload
	ON resposta_upload.id_resposta = resposta.id_resposta
JOIN questao
	ON resposta.id_questao = questao.id_questao
JOIN upload
	ON upload.id_questao = questao.id_questao
WHERE resposta.id_tentativa = 1;
-- ============================== Select Estrutura do Tabuleiro ==============================
SELECT 
    s.id_secao,
    s.titulo_secao,
    s.descricao_secao,
    c.id_casa,
    c.titulo_casa,
    c.data_limite_casa,
    t.id_tarefa,
    t.titulo_tarefa,
    t.prazo_tarefa,
    IF(COUNT(DISTINCT ten.id_tentativa) > 0, 1, 0) AS tarefa_concluida
FROM secao s
LEFT JOIN casa c ON s.id_secao = c.id_secao
LEFT JOIN tarefa t ON c.id_casa = t.id_casa
LEFT JOIN tentativa ten ON t.id_tarefa = ten.id_tarefa 
    AND ten.id_usuario = 1 
    AND ten.status_tentativa = 'concluida'
GROUP BY 
    s.id_secao, c.id_casa, t.id_tarefa
ORDER BY 
    s.id_secao ASC, 
    c.id_casa ASC, 
    t.prazo_tarefa ASC;