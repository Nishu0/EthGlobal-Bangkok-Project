-- AlterTable
CREATE SEQUENCE bet_questionid_seq;
ALTER TABLE "Bet" ALTER COLUMN "questionId" SET DEFAULT nextval('bet_questionid_seq');
ALTER SEQUENCE bet_questionid_seq OWNED BY "Bet"."questionId";
