-- ============================================================
-- Migration: rename "Ayesha" → "Chotu" in existing expense rows
--
-- Run this ONCE in the Supabase SQL Editor:
--   Dashboard → SQL Editor → New query → paste → Run
--
-- Safe to run more than once (WHERE clauses are idempotent).
-- ============================================================

-- 1. Fix rows where Ayesha was the payer
UPDATE expenses
SET paid_by = 'Chotu'
WHERE paid_by = 'Ayesha';

-- 2. Fix rows where Ayesha appears in the split_between array
UPDATE expenses
SET split_between = array_replace(split_between, 'Ayesha', 'Chotu')
WHERE 'Ayesha' = ANY(split_between);

-- 3. Verify — should return 0 rows if migration is complete
SELECT id, paid_by, split_between
FROM expenses
WHERE paid_by = 'Ayesha'
   OR 'Ayesha' = ANY(split_between);
