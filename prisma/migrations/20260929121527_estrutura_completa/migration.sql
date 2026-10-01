-- CreateEnum
CREATE TYPE "OcorrenciaStatus" AS ENUM ('aberta', 'em_andamento', 'resolvida');

-- CreateEnum
CREATE TYPE "AlertaStatus" AS ENUM ('aberto', 'lido', 'resolvido');

-- AlterTable
ALTER TABLE "alerts" ADD COLUMN     "dispositivoId" UUID,
ADD COLUMN     "salaId" UUID,
ADD COLUMN     "status" "AlertaStatus" NOT NULL DEFAULT 'aberto';

-- AlterTable
ALTER TABLE "cameras" ADD COLUMN     "endereco" TEXT,
ADD COLUMN     "localizacao" TEXT,
ADD COLUMN     "tipo" TEXT NOT NULL DEFAULT 'IP';

-- AlterTable
ALTER TABLE "readings" ADD COLUMN     "dispositivoId" UUID;

-- AlterTable
ALTER TABLE "sensors" ADD COLUMN     "dispositivoId" UUID;

-- CreateTable
CREATE TABLE "dispositivos" (
    "id" UUID NOT NULL,
    "codigo" TEXT,
    "nome" TEXT NOT NULL,
    "tipo" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'offline',
    "localizacao" TEXT,
    "ip" TEXT,
    "macAddress" TEXT,
    "firmware" TEXT,
    "ultimoContato" TIMESTAMP(3),
    "ativo" BOOLEAN NOT NULL DEFAULT true,
    "salaId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "dispositivos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "epis" (
    "id" UUID NOT NULL,
    "nome" TEXT NOT NULL,
    "descricao" TEXT,
    "status" TEXT NOT NULL DEFAULT 'ativo',
    "obrigatorio" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "epis_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ocorrencias" (
    "id" UUID NOT NULL,
    "tipo" TEXT NOT NULL,
    "descricao" TEXT,
    "dataHora" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "status" "OcorrenciaStatus" NOT NULL DEFAULT 'aberta',
    "salaId" UUID,
    "cameraId" UUID,
    "dispositivoId" UUID,
    "epiId" UUID,
    "usuarioId" UUID,

    CONSTRAINT "ocorrencias_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "dispositivos_codigo_key" ON "dispositivos"("codigo");

-- CreateIndex
CREATE INDEX "dispositivos_salaId_idx" ON "dispositivos"("salaId");

-- CreateIndex
CREATE INDEX "dispositivos_status_idx" ON "dispositivos"("status");

-- CreateIndex
CREATE INDEX "dispositivos_ativo_idx" ON "dispositivos"("ativo");

-- CreateIndex
CREATE INDEX "epis_status_idx" ON "epis"("status");

-- CreateIndex
CREATE INDEX "epis_obrigatorio_idx" ON "epis"("obrigatorio");

-- CreateIndex
CREATE INDEX "ocorrencias_salaId_idx" ON "ocorrencias"("salaId");

-- CreateIndex
CREATE INDEX "ocorrencias_cameraId_idx" ON "ocorrencias"("cameraId");

-- CreateIndex
CREATE INDEX "ocorrencias_dispositivoId_idx" ON "ocorrencias"("dispositivoId");

-- CreateIndex
CREATE INDEX "ocorrencias_epiId_idx" ON "ocorrencias"("epiId");

-- CreateIndex
CREATE INDEX "ocorrencias_usuarioId_idx" ON "ocorrencias"("usuarioId");

-- CreateIndex
CREATE INDEX "ocorrencias_dataHora_idx" ON "ocorrencias"("dataHora" DESC);

-- CreateIndex
CREATE INDEX "ocorrencias_status_idx" ON "ocorrencias"("status");

-- CreateIndex
CREATE INDEX "alerts_salaId_dataHora_idx" ON "alerts"("salaId", "dataHora" DESC);

-- CreateIndex
CREATE INDEX "alerts_dispositivoId_dataHora_idx" ON "alerts"("dispositivoId", "dataHora" DESC);

-- CreateIndex
CREATE INDEX "alerts_status_idx" ON "alerts"("status");

-- CreateIndex
CREATE INDEX "cameras_online_idx" ON "cameras"("online");

-- CreateIndex
CREATE INDEX "readings_dispositivoId_dataHora_idx" ON "readings"("dispositivoId", "dataHora" DESC);

-- CreateIndex
CREATE INDEX "salas_ativo_idx" ON "salas"("ativo");

-- CreateIndex
CREATE INDEX "sensors_dispositivoId_idx" ON "sensors"("dispositivoId");

-- CreateIndex
CREATE INDEX "sensors_ativo_idx" ON "sensors"("ativo");

-- CreateIndex
CREATE INDEX "users_ativo_idx" ON "users"("ativo");

-- AddForeignKey
ALTER TABLE "dispositivos" ADD CONSTRAINT "dispositivos_salaId_fkey" FOREIGN KEY ("salaId") REFERENCES "salas"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sensors" ADD CONSTRAINT "sensors_dispositivoId_fkey" FOREIGN KEY ("dispositivoId") REFERENCES "dispositivos"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "readings" ADD CONSTRAINT "readings_dispositivoId_fkey" FOREIGN KEY ("dispositivoId") REFERENCES "dispositivos"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "alerts" ADD CONSTRAINT "alerts_salaId_fkey" FOREIGN KEY ("salaId") REFERENCES "salas"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "alerts" ADD CONSTRAINT "alerts_dispositivoId_fkey" FOREIGN KEY ("dispositivoId") REFERENCES "dispositivos"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ocorrencias" ADD CONSTRAINT "ocorrencias_salaId_fkey" FOREIGN KEY ("salaId") REFERENCES "salas"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ocorrencias" ADD CONSTRAINT "ocorrencias_cameraId_fkey" FOREIGN KEY ("cameraId") REFERENCES "cameras"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ocorrencias" ADD CONSTRAINT "ocorrencias_dispositivoId_fkey" FOREIGN KEY ("dispositivoId") REFERENCES "dispositivos"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ocorrencias" ADD CONSTRAINT "ocorrencias_epiId_fkey" FOREIGN KEY ("epiId") REFERENCES "epis"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ocorrencias" ADD CONSTRAINT "ocorrencias_usuarioId_fkey" FOREIGN KEY ("usuarioId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;
