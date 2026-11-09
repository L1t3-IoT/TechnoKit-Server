ALTER TABLE "products" ADD COLUMN "unit_label" text;--> statement-breakpoint
ALTER TABLE "products" ADD COLUMN "card_specs" jsonb DEFAULT '[]'::jsonb NOT NULL;--> statement-breakpoint
ALTER TABLE "products" ADD COLUMN "status_text" text;--> statement-breakpoint
ALTER TABLE "products" ADD COLUMN "status_note" text;