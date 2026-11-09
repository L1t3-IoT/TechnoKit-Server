import {
  pgTable, serial, text, integer, boolean, timestamp, uuid, jsonb, primaryKey, index, real,
} from 'drizzle-orm/pg-core';

export type SpecValue = string | number | boolean | (string | number)[];

export const users = pgTable('users', {
  id: uuid('id').primaryKey().defaultRandom(),
  email: text('email').notNull().unique(),
  passwordHash: text('password_hash').notNull(),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
});

export const sessions = pgTable('sessions', {
  tokenHash: text('token_hash').primaryKey(),
  userId: uuid('user_id').notNull().references(() => users.id, { onDelete: 'cascade' }),
  expiresAt: timestamp('expires_at', { withTimezone: true }).notNull(),
});

export const categories = pgTable('categories', {
  id: serial('id').primaryKey(),
  slug: text('slug').notNull().unique(),
  name: text('name').notNull(),
  sortOrder: integer('sort_order').notNull().default(0),
});

export const products = pgTable('products', {
  id: serial('id').primaryKey(),
  sku: text('sku').notNull().unique(),
  categoryId: integer('category_id').notNull().references(() => categories.id),
  name: text('name').notNull(),
  brand: text('brand'),
  description: text('description'),
  priceCents: integer('price_cents').notNull(),
  imageUrl: text('image_url'),
  inStock: boolean('in_stock').notNull().default(true),
  // Підпис ціни на картці: "/ рама", "/ мотор" тощо
  unitLabel: text('unit_label'),
  // Дві ключові характеристики для картки каталогу
  cardSpecs: jsonb('card_specs').$type<{ label: string; value: string }[]>().notNull().default([]),
  // Статус сумісності на картці (поки статичний; далі рахуватиметься від збірки)
  statusText: text('status_text'),
  statusNote: text('status_note'),
  // Характеристики різні для кожної категорії, тому jsonb.
  // Напр.: { "cells": [4,6], "stack_mount": "30.5x30.5", "wheelbase_mm": 225 }
  specs: jsonb('specs').$type<Record<string, SpecValue>>().notNull().default({}),
  // true — характеристики звірено з джерелом (сторінка виробника/магазину); false — орієнтовні дані
  verified: boolean('verified').notNull().default(false),
  sourceUrl: text('source_url'),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
}, (t) => [index('products_category_idx').on(t.categoryId)]);

// Дрони: реальні моделі (kind='model') і еталонні збірки TechnoKit з деталей каталогу (kind='reference').
export const drones = pgTable('drones', {
  id: serial('id').primaryKey(),
  slug: text('slug').notNull().unique(),
  name: text('name').notNull(),
  brand: text('brand'),
  kind: text('kind').notNull().default('reference'), // 'model' | 'reference'
  segment: text('segment').notNull(),                // '3.5' | '5' | '7' ...
  propInch: real('prop_inch'),
  cells: jsonb('cells').$type<number[]>().notNull().default([]),
  weightG: integer('weight_g'),                      // злітна вага з акумулятором, г
  summary: text('summary'),
  specs: jsonb('specs').$type<Record<string, SpecValue>>().notNull().default({}),
  imageUrl: text('image_url'),
  sourceUrl: text('source_url'),
  verified: boolean('verified').notNull().default(false),
  sortOrder: integer('sort_order').notNull().default(0),
});

export const droneParts = pgTable('drone_parts', {
  droneId: integer('drone_id').notNull().references(() => drones.id, { onDelete: 'cascade' }),
  productId: integer('product_id').notNull().references(() => products.id, { onDelete: 'cascade' }),
  quantity: integer('quantity').notNull().default(1),
}, (t) => [primaryKey({ columns: [t.droneId, t.productId] })]);

export const builds = pgTable('builds', {
  id: uuid('id').primaryKey().defaultRandom(),
  userId: uuid('user_id').notNull().references(() => users.id, { onDelete: 'cascade' }),
  name: text('name').notNull(),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
});

export const buildItems = pgTable('build_items', {
  buildId: uuid('build_id').notNull().references(() => builds.id, { onDelete: 'cascade' }),
  productId: integer('product_id').notNull().references(() => products.id),
  quantity: integer('quantity').notNull().default(1),
}, (t) => [primaryKey({ columns: [t.buildId, t.productId] })]);
