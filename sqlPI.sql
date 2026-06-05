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

INSERT INTO subturma (cod_subtuma) VALUES ('SUB00');

SET @ultimo_id_subturma = LAST_INSERT_ID();

INSERT INTO
    turma_subturma (
        id_turma,
        id_subturma,
        id_curso,
        semestre_id_semestre
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
