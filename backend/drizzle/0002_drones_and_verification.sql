CREATE TABLE "drone_parts" (
	"drone_id" integer NOT NULL,
	"product_id" integer NOT NULL,
	"quantity" integer DEFAULT 1 NOT NULL,
	CONSTRAINT "drone_parts_drone_id_product_id_pk" PRIMARY KEY("drone_id","product_id")
);
--> statement-breakpoint
CREATE TABLE "drones" (
	"id" serial PRIMARY KEY NOT NULL,
	"slug" text NOT NULL,
	"name" text NOT NULL,
	"brand" text,
	"kind" text DEFAULT 'reference' NOT NULL,
	"segment" text NOT NULL,
	"prop_inch" real,
	"cells" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"weight_g" integer,
	"summary" text,
	"specs" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"image_url" text,
	"source_url" text,
	"verified" boolean DEFAULT false NOT NULL,
	"sort_order" integer DEFAULT 0 NOT NULL,
	CONSTRAINT "drones_slug_unique" UNIQUE("slug")
);
--> statement-breakpoint
ALTER TABLE "products" ADD COLUMN "verified" boolean DEFAULT false NOT NULL;--> statement-breakpoint
ALTER TABLE "products" ADD COLUMN "source_url" text;--> statement-breakpoint
ALTER TABLE "drone_parts" ADD CONSTRAINT "drone_parts_drone_id_drones_id_fk" FOREIGN KEY ("drone_id") REFERENCES "public"."drones"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "drone_parts" ADD CONSTRAINT "drone_parts_product_id_products_id_fk" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE cascade ON UPDATE no action;