-- =============================================
-- 🔒 Row Level Security (RLS) Policies
-- Star Office - Supabase
-- =============================================

-- Enable RLS on all tables
ALTER TABLE tasks_calendar ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_inventory ENABLE ROW LEVEL SECURITY;
ALTER TABLE activity_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE ads_logs ENABLE ROW LEVEL SECURITY;

-- =============================================
-- Policy: tasks_calendar
-- Authenticated users can view all tasks
-- Only the creator (or admin) can edit/delete
-- =============================================
CREATE POLICY "Allow read for authenticated" ON tasks_calendar
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow insert for authenticated" ON tasks_calendar
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Allow update own tasks" ON tasks_calendar
  FOR UPDATE USING (
    auth.uid()::text = created_by OR
    auth.jwt()->>'email' = 'paopaony012@gmail.com'
  );

CREATE POLICY "Allow delete own tasks" ON tasks_calendar
  FOR DELETE USING (
    auth.uid()::text = created_by OR
    auth.jwt()->>'email' = 'paopaony012@gmail.com'
  );

-- =============================================
-- Policy: product_inventory
-- All authenticated can read
-- Only admin and team can insert/update
-- =============================================
CREATE POLICY "Allow read inventory" ON product_inventory
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow insert inventory" ON product_inventory
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Allow update inventory" ON product_inventory
  FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "Admin delete inventory" ON product_inventory
  FOR DELETE USING (auth.jwt()->>'email' = 'paopaony012@gmail.com');

-- =============================================
-- Policy: activity_logs
-- Everyone authenticated can read and insert
-- Only admin can delete
-- =============================================
CREATE POLICY "Allow read logs" ON activity_logs
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow insert logs" ON activity_logs
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Admin delete logs" ON activity_logs
  FOR DELETE USING (auth.jwt()->>'email' = 'paopaony012@gmail.com');

-- =============================================
-- Policy: ads_logs
-- All authenticated can read
-- Admin can do everything
-- =============================================
CREATE POLICY "Allow read ads" ON ads_logs
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow insert ads" ON ads_logs
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Admin update ads" ON ads_logs
  FOR UPDATE USING (auth.jwt()->>'email' = 'paopaony012@gmail.com');

CREATE POLICY "Admin delete ads" ON ads_logs
  FOR DELETE USING (auth.jwt()->>'email' = 'paopaony012@gmail.com');

-- =============================================
-- Add 'created_by' column to tasks_calendar
-- for user-specific task ownership
-- =============================================
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'tasks_calendar' AND column_name = 'created_by'
  ) THEN
    ALTER TABLE tasks_calendar ADD COLUMN created_by TEXT DEFAULT '';
  END IF;
END $$;

-- =============================================
-- Allow anonymous (guest) read-only access
-- for tables that should be publicly viewable
-- =============================================
CREATE POLICY "Allow anon read tasks" ON tasks_calendar
  FOR SELECT USING (auth.role() = 'anon');

CREATE POLICY "Allow anon read inventory" ON product_inventory
  FOR SELECT USING (auth.role() = 'anon');

CREATE POLICY "Allow anon read logs" ON activity_logs
  FOR SELECT USING (auth.role() = 'anon');

CREATE POLICY "Allow anon read ads" ON ads_logs
  FOR SELECT USING (auth.role() = 'anon');

-- Allow anon to insert (for guest mode functionality)
CREATE POLICY "Allow anon insert logs" ON activity_logs
  FOR INSERT WITH CHECK (auth.role() = 'anon');

CREATE POLICY "Allow anon insert tasks" ON tasks_calendar
  FOR INSERT WITH CHECK (auth.role() = 'anon');
