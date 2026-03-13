-- ===== Star Office - Supabase Schema Setup =====
-- Run this in Supabase SQL Editor: https://supabase.com/dashboard

-- 1. Calendar Tasks
CREATE TABLE IF NOT EXISTS public.tasks_calendar (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    task_name TEXT NOT NULL,
    status TEXT DEFAULT 'pending' NOT NULL
);
ALTER TABLE public.tasks_calendar DISABLE ROW LEVEL SECURITY;

-- 2. Ad Bot Logs
CREATE TABLE IF NOT EXISTS public.ads_logs (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    campaign_name TEXT NOT NULL,
    roas NUMERIC,
    action TEXT NOT NULL,
    status TEXT DEFAULT 'active' NOT NULL
);
ALTER TABLE public.ads_logs DISABLE ROW LEVEL SECURITY;

-- 3. System Activity Logs
CREATE TABLE IF NOT EXISTS public.activity_logs (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    category TEXT NOT NULL,
    action_detail TEXT NOT NULL,
    account_target TEXT,
    system_status TEXT DEFAULT 'success' NOT NULL
);
ALTER TABLE public.activity_logs DISABLE ROW LEVEL SECURITY;

-- 4. Product Inventory (NEW)
CREATE TABLE IF NOT EXISTS public.product_inventory (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    product_name TEXT NOT NULL,
    product_link TEXT DEFAULT '',
    price NUMERIC DEFAULT 0,
    commission TEXT DEFAULT '0%',
    ai_caption TEXT DEFAULT ''
);
ALTER TABLE public.product_inventory DISABLE ROW LEVEL SECURITY;

-- Sample data
INSERT INTO public.tasks_calendar (task_name, status) VALUES 
('สั่งทีมตัดต่อทำคลิปสบู่รักษาสิว', 'pending'),
('หาแรฟเฟอเรนซ์ ไมค์ติดปกเสื้อ', 'completed');
