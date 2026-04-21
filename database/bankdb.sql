--
-- PostgreSQL database dump
--

\restrict GkgKSKJva2ceUhkKjf7HW1hMRZ2Akbc1yhUfb7fyfkthCrwMXAN5SA9FyoG6k8H

-- Dumped from database version 18.3 (Postgres.app)
-- Dumped by pg_dump version 18.3 (Postgres.app)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: update_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accounts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    name character varying(150) NOT NULL,
    iban character varying(34) NOT NULL,
    balance numeric(18,2) DEFAULT 0 NOT NULL,
    currency character varying(10) DEFAULT 'TRY'::character varying NOT NULL,
    account_type character varying(50) DEFAULT 'checking'::character varying NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: transfers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transfers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    sender_account_id uuid NOT NULL,
    receiver_iban character varying(34) NOT NULL,
    receiver_name character varying(150),
    amount numeric(18,2) NOT NULL,
    currency character varying(10) DEFAULT 'TRY'::character varying NOT NULL,
    description text,
    status character varying(20) DEFAULT 'completed'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT transfers_amount_check CHECK ((amount > (0)::numeric))
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    full_name character varying(150) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    phone character varying(20),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.accounts (id, user_id, name, iban, balance, currency, account_type, is_active, created_at, updated_at) FROM stdin;
5a4a2b24-8205-4ac4-b6b0-af77dfeb7fc8	36e6f19b-18d0-4a23-8ab4-f8a2b15a7cf7	Yatırım Hesabı	TR8942858431654370000000	2.00	TRY	savings	t	2026-04-19 15:30:14.055804+03	2026-04-19 15:33:08.362705+03
23856365-b886-4a03-98c7-db31aa34fd5d	4035b4db-5e43-41e9-aa29-27553a1c7d05	Yatırım Hesabı	TR5813522495645107000000	2740.00	TRY	savings	t	2026-04-19 15:36:03.894145+03	2026-04-19 17:27:36.876052+03
46a02fe9-0ad2-49f3-8786-d43d52e23d02	4035b4db-5e43-41e9-aa29-27553a1c7d05	Cari Hesap	TR3187068158466878000000	1450.00	TRY	checking	t	2026-04-19 15:24:52.30342+03	2026-04-19 17:36:11.864224+03
91863d68-1a2e-457b-8084-31108c24e4e9	36e6f19b-18d0-4a23-8ab4-f8a2b15a7cf7	Vadesiz Hesap	TR8346636140134714000000	3850.00	TRY	checking	t	2026-04-19 15:12:30.342891+03	2026-04-19 17:36:11.864224+03
\.


--
-- Data for Name: transfers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.transfers (id, sender_account_id, receiver_iban, receiver_name, amount, currency, description, status, created_at) FROM stdin;
3c9fc79c-e2a0-4a40-85f1-d7dc28c43395	46a02fe9-0ad2-49f3-8786-d43d52e23d02	TR5813522495645107000000	zeynep büşra çınar	1000.00	TRY	\N	completed	2026-04-19 15:42:26.900361+03
1caa0a55-862c-4b76-915e-39c624e99f2d	46a02fe9-0ad2-49f3-8786-d43d52e23d02	TR5813522495645107000000	zey nep büşra çınar	500.00	TRY	\N	completed	2026-04-19 16:39:44.38282+03
b0d9736f-6aa0-4db6-9a39-bf694a7a2002	46a02fe9-0ad2-49f3-8786-d43d52e23d02	TR5813522495645107000000	zeynep büşra çınar	500.00	TRY	\N	completed	2026-04-19 16:43:57.493246+03
585c47a0-9f00-4cb1-abc4-8bb5efb53d3b	46a02fe9-0ad2-49f3-8786-d43d52e23d02	TR8346636140134714000000	zeynep büşra çınar	200.00	TRY	\N	completed	2026-04-19 17:03:06.524548+03
e5174162-db71-4e4d-9178-c491a8dcdf14	46a02fe9-0ad2-49f3-8786-d43d52e23d02	TR8346636140134714000000	zeynep büşra çınar	500.00	TRY	\N	completed	2026-04-19 17:22:59.077809+03
4306ef84-2bd6-44b4-8f2c-6eb47bf5cba1	91863d68-1a2e-457b-8084-31108c24e4e9	TR5813522495645107000000	Ali çınar	700.00	TRY	\N	completed	2026-04-19 17:27:36.876052+03
9ed55ad7-b76f-404e-a3a2-1409ee92b302	46a02fe9-0ad2-49f3-8786-d43d52e23d02	TR8346636140134714000000	zeynep büşra çınar	450.00	TRY	\N	completed	2026-04-19 17:31:58.106393+03
7f310575-159f-4b4a-bd31-a7a6ab99f8f9	91863d68-1a2e-457b-8084-31108c24e4e9	TR3187068158466878000000	Ali çınar	250.00	TRY	\N	completed	2026-04-19 17:35:00.260408+03
8ccd8d76-a20e-4fa8-8e7c-b3b4566422ec	46a02fe9-0ad2-49f3-8786-d43d52e23d02	TR8346636140134714000000	zeynep büşra çınar	650.00	TRY	\N	completed	2026-04-19 17:36:11.864224+03
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, full_name, email, password_hash, phone, created_at, updated_at) FROM stdin;
36e6f19b-18d0-4a23-8ab4-f8a2b15a7cf7	Zeynep Büşra Çınar	zeynep@test.com	$2a$12$jY4zZQ5RnUzy9GuDQobtT.OMmm/C9iX6KSyfPLvNHPO7VBsZ12oq2	\N	2026-04-19 15:06:29.630929+03	2026-04-19 15:06:29.630929+03
4035b4db-5e43-41e9-aa29-27553a1c7d05	Ali Çınar	ali@test.com	$2a$12$6g4HxSzTDs/iG46.O9lDt.CZ13KzONMaChAWr7S2r7NyjM3Oh9wrW	\N	2026-04-19 15:24:21.683568+03	2026-04-19 15:24:21.683568+03
\.


--
-- Name: accounts accounts_iban_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_iban_key UNIQUE (iban);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: transfers transfers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_accounts_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_accounts_user_id ON public.accounts USING btree (user_id);


--
-- Name: idx_transfers_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_transfers_created_at ON public.transfers USING btree (created_at DESC);


--
-- Name: idx_transfers_sender; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_transfers_sender ON public.transfers USING btree (sender_account_id);


--
-- Name: accounts trg_accounts_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_accounts_updated BEFORE UPDATE ON public.accounts FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


--
-- Name: users trg_users_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_users_updated BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


--
-- Name: accounts accounts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: transfers transfers_sender_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_sender_account_id_fkey FOREIGN KEY (sender_account_id) REFERENCES public.accounts(id);


--
-- PostgreSQL database dump complete
--

\unrestrict GkgKSKJva2ceUhkKjf7HW1hMRZ2Akbc1yhUfb7fyfkthCrwMXAN5SA9FyoG6k8H

