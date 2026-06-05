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

-- ============================== Select para popular Tarefa do Aluno ==============================
SELECT
    t.id_tarefa,
    t.titulo_tarefa,
    t.prazo_tarefa,
    c.titulo_casa,
    c.data_limite_casa,
    s.titulo_secao,
    crs.nome_curso
FROM turma_usuario tu
JOIN turma_subturma ts
    ON tu.id_turma_subturma = ts.id_turma_subturma
JOIN curso crs
    ON ts.id_curso = crs.id_curso
JOIN casa c
    ON c.id_secao = s.id_secao
JOIN tarefa t
    ON t.id_casa = c.id_casa
WHERE tu.id_usuario = 1
ORDER BY t.prazo_tarefa;

-- ============================== Select para Popular Corrige Tarefa ==============================
SELECT
    u.nome_usuario,
    u.sobrenome_usuario,
    ten.id_tentativa,
    ten.status_tentativa,
    ten.data_tentativa,
    q.enunciado_questao,
    q.tipo_questao,
    r.id_resposta,
    r.nota_resposta,
    r.feedback_resposta
FROM tentativa ten
JOIN usuario u
    ON ten.id_usuario = u.id_usuario
JOIN resposta r
    ON r.id_tentativa = ten.id_tentativa
JOIN questao q
    ON r.id_questao = q.id_questao
WHERE ten.id_tarefa = 1
ORDER BY ten.id_tentativa, q.id_questao;

-- ============================== Select para Popular Corrige Tarefa (Alternativa) ==============================
SELECT
    r.id_resposta,
    a.texto_alternativa,
    a.correta
FROM resposta r
JOIN resposta_alternativa ra
    ON ra.id_resposta = r.id_resposta
JOIN alternativa a
    ON ra.id_alternativa = a.id_alternativa
WHERE r.id_tentativa = 1;

-- ============================== Select para Popular Corrige Tarefa (Dissertativa) ==============================
SELECT
    r.id_resposta,
    rd.resposta AS texto_resposta_aluno,
    d.resposta_modelo_dissertativa
FROM resposta r
JOIN resposta_dissertativa rd
    ON rd.id_resposta = r.id_resposta
JOIN questao q
    ON r.id_questao = q.id_questao
JOIN dissertativa d
    ON d.id_questao = q.id_questao
WHERE r.id_tentativa = 1;

-- ============================== Select para Popular Corrige Tarefa (Upload) ==============================
SELECT
    r.id_resposta,
    ru.arquivo_resposta,
    up.titulo_upload,
    up.arquivo_modelo_upload
FROM resposta r
JOIN resposta_upload ru
    ON ru.id_resposta = r.id_resposta
JOIN questao q
    ON r.id_questao = q.id_questao
JOIN upload up
    ON up.id_questao = q.id_questao
WHERE r.id_tentativa = 1;