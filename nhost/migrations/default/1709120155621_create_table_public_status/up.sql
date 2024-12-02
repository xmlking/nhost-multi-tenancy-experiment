CREATE TABLE public.status
(
    value       text PRIMARY KEY,
    description text NOT NULL
);
COMMENT ON TABLE public.status IS 'status enum';
---
INSERT INTO public.status (value, description) VALUES ('starter', 'Active');
INSERT INTO public.status (value, description) VALUES ('disabled', 'Disabled');
INSERT INTO public.status (value, description) VALUES ('closed', 'Closed');