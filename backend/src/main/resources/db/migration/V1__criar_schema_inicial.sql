CREATE TABLE usuarios(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha_hash VARCHAR(255) NOT NULL,
    criado_em TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE SEQUENCE numero_conta_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE contas(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    numero_conta INTEGER UNIQUE NOT NULL DEFAULT nextval('numero_conta_seq'),
    usuario_id UUID NOT NULL UNIQUE,
    saldo NUMERIC(18, 2) NOT NULL DEFAULT 0 CHECK ( saldo >= 0),
    criado_em TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

CREATE TABLE chaves_pix(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    chave VARCHAR(255) UNIQUE NOT NULL,
    tipo VARCHAR(20) NOT NULL CHECK(tipo IN('CPF', 'EMAIL', 'TELEFONE', 'ALEATORIA')),
    conta_id UUID NOT NULL,
    criado_em TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_chaves_pix_conta FOREIGN KEY (conta_id) REFERENCES contas(id)
);

CREATE INDEX idx_chaves_pix_conta ON chaves_pix (conta_id);
