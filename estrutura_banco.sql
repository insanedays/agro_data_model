-- ---
-- Table 'talhao'
-- ---

DROP TABLE IF EXISTS `talhao`;

CREATE TABLE `talhao` (
    `id` INTEGER NOT NULL AUTO_INCREMENT COMMENT 'Identificador único ao talhão (chave primária), ele é autoincremental.',
    `nome` VARCHAR(60) NOT NULL UNIQUE COMMENT 'Nome do talhão.',
    `hectares` DECIMAL NOT NULL CHECK (hectares > 0) COMMENT 'Tamanho do talhão em hectares.',
    `descricao` VARCHAR(255) NULL DEFAULT NULL COMMENT 'Descrição do talhão.',
    `centroide_latitude` DOUBLE NOT NULL COMMENT 'Latitude do centro do talhão.',
    `centroide_longitude` DOUBLE NOT NULL COMMENT 'Longitude do centro do talhão.',
    PRIMARY KEY (`id`)
) COMMENT 'Tabela de informações do talhão da fazenda';

-- ---
-- Table 'area'

DROP TABLE IF EXISTS `area`;

CREATE TABLE `area` (
    `id` INTEGER NOT NULL AUTO_INCREMENT COMMENT 'Identificador único da área (chave primária), ele é autoincremental.',
    `id_talhao` INTEGER NOT NULL COMMENT 'Chave estrangeira que referencia o talhão.',
    `nome` VARCHAR(60) NOT NULL UNIQUE COMMENT 'Nome dado à área pelo usuário para facilitar a identificação.',
    `centroide_latitude` DOUBLE NOT NULL COMMENT 'Latitude do centro da área.',
    `centoride_longitude` DOUBLE NOT NULL COMMENT 'Longitude do centro da área.',
    `tamanho` DECIMAL NOT NULL CHECK (tamanho > 0) COMMENT 'Tamanho da área cadastrada.',
    `unidade_de_medida` VARCHAR(10) NOT NULL COMMENT 'Informa se o tamanho está cadastrado em metros quadrados ou hectares.',
    PRIMARY KEY (`id`),
    FOREIGN KEY (id_talhao) REFERENCES `talhao` (`id`),
    CONSTRAINT chk_unidade_de_medida CHECK (chk_unidade_de_medida IN ('metros','hectares'))
) COMMENT 'Traz detalhes sobre as áreas dentro do talhão';

-- ---
-- Table 'sensor'
-- ---

DROP TABLE IF EXISTS `sensor`;

CREATE TABLE `sensor` (
    `id` INTEGER NOT NULL AUTO_INCREMENT COMMENT 'Identificador único do sensor (chave primária), ele é autoincremental.',
    `id_talhao` INTEGER NOT NULL COMMENT 'Chave estrangeira que referencia a tabela Área.',
    `nome` VARCHAR(60) NOT NULL COMMENT 'Nome criado para o usuário para facilitar a identificação do sensor.',
    `unidade_de_medida` VARCHAR(10) NOT NULL COMMENT 'Unidade de medida usada pelo sensor, cada tipo de sensor tem uma unidade padrão.',
    `tipo` VARCHAR(20) NOT NULL COMMENT 'Tipo do sensor: pH, umidade, potássio, fósforo.',
    `profundidade_instalada` DECIMAL NOT NULL COMMENT 'Profundidade em que o sensor foi instalado.',
    `instalacao_latitude` DOUBLE NOT NULL COMMENT 'Latitude da instalação do sensor.',
    `instalacao_longitude` DOUBLE NOT NULL COMMENT 'Longitude da instalação do sensor.',
    `area_de_alcance` DECIMAL NOT NULL CHECK (area_de_alcance > 0) COMMENT 'Área que o sensor consegue cobrir.',
    PRIMARY KEY (`id`),
    FOREIGN KEY (id_talhao) REFERENCES `talhao` (`id`),
    CONSTRAINT chk_unidade_de_medida CHECK (chk_unidade_de_medida IN ('percentual','mg/kg','ppm')),
    CONSTRAINT chk_tipo CHECK (tipo IN ('sensor de umidade','sensor de ph','sensor de potássio','sensor de fósforo'))
) COMMENT 'Tabela de informações dos sensores instalados';


-- ---
-- Table 'leitura'
-- ---

DROP TABLE IF EXISTS `leitura`;

CREATE TABLE `leitura` (
    `id` INTEGER NOT NULL AUTO_INCREMENT COMMENT 'Identificador único da leitura (chave primária), ele é autoincremental.',
    `id_sensor` INTEGER NOT NULL COMMENT 'Chave estrangeira que referencia a tabela Sensor.',
    `data_hora` DATETIME NOT NULL COMMENT 'Data e hora da leitura.',
    `valor` INTEGER NOT NULL COMMENT 'Valor registrado pela leitura.',
    PRIMARY KEY (`id`),
    FOREIGN KEY (id_sensor) REFERENCES `sensor` (`id`)
  ) COMMENT 'Tabela de leituras realizadas pelos sensores';

-- ---
-- Table 'acoes'
-- ---

DROP TABLE IF EXISTS `acoes`;

CREATE TABLE `acoes` (
    `id` INTEGER NOT NULL AUTO_INCREMENT COMMENT 'Identificador único da ação (chave primária), ele é autoincremental.',
    `id_area` INTEGER NOT NULL COMMENT 'Chave estrangeira que referencia a tabela Área.',
    `id_produto` INTEGER NOT NULL COMMENT 'Chave estrangeira que referencia a tabela Produto.',
    `data_hora` DATETIME NOT NULL COMMENT 'Data e hora da ação.',
    `quantidade_aplicada` DECIMAL NOT NULL CHECK (quantidade_aplicada > 0) COMMENT 'Quantidade do produto aplicada.',
    PRIMARY KEY (`id`),
    FOREIGN KEY (id_area) REFERENCES `area` (`id`),
    FOREIGN KEY (id_produto) REFERENCES `manejo` (`id`)
) COMMENT 'Tabela de ações realizadas nas áreas';

-- ---
-- Table 'manejo'
-- ---

DROP TABLE IF EXISTS `manejo`;

CREATE TABLE `manejo` (
    `id` INTEGER NOT NULL AUTO_INCREMENT COMMENT 'Identificador único do produto (chave primária), ele é autoincremental.',
    `nome` VARCHAR(60) NOT NULL COMMENT 'Nome do produto utilizado no manejo.',
    `tipo` VARCHAR(20) NOT NULL COMMENT 'Tipo do produto: irrigação, aplicação de fertilizantes, correção de solo.',
    PRIMARY KEY (`id`),
    CONSTRAINT chk_tipo CHECK (tipo IN ('irrigação', 'aplicação de fertilizantes', 'correção de solo'))
) COMMENT 'Tabela de manejo de insumos utilizados';

-- ---
-- Table 'safra'
-- ---

DROP TABLE IF EXISTS `safra`;

CREATE TABLE `safra` (
    `id` INTEGER NOT NULL AUTO_INCREMENT COMMENT 'Identificador único da safra (chave primária), ele é autoincremental.',
    `id_talhao` INTEGER NOT NULL COMMENT 'Chave estrangeira que referencia o talhão.',
    `cultura` VARCHAR(100) NOT NULL COMMENT 'Tipo de cultura plantada.',
    `densidade_de_plantio` DECIMAL NOT NULL CHECK (densidade_de_plantio > 0) COMMENT 'Número de plantas por hectare.',
    `area_de_plantio` DECIMAL NOT NULL CHECK (area_de_plantio > 0) COMMENT 'Área plantada com a cultura.',
    `data_inicio_plantio` DATE NOT NULL COMMENT 'Data de início do plantio.',
    `data_fim_plantio` DATE NULL DEFAULT NULL COMMENT 'Data de fim do plantio.',
    `data_emergencia` DATE NULL DEFAULT NULL COMMENT 'Data de emergência da cultura.',
    PRIMARY KEY (`id`),
    FOREIGN KEY (id_talhao) REFERENCES `talhao` (`id`)
) COMMENT 'Tabela contendo informações da safra plantada';

-- ---
-- Table Properties
-- ---

ALTER TABLE `talhao` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
ALTER TABLE `area` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
ALTER TABLE `sensor` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
ALTER TABLE `leitura` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
ALTER TABLE `acoes` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
ALTER TABLE `manejo` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
ALTER TABLE `safra` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
