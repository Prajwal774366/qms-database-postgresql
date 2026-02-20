--
-- PostgreSQL database dump
--

\restrict ynofwkyRvIQVoJnZzwYwWzak5nTc46k30oUmsTZqgS7tHGkaMqXZLBC7ueO8TPo

-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.0

-- Started on 2026-02-20 20:08:33

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
-- TOC entry 869 (class 1247 OID 16422)
-- Name: business_impact_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.business_impact_enum AS ENUM (
    'Customer rejection',
    'scrap',
    'rework',
    'stoppage'
);


ALTER TYPE public.business_impact_enum OWNER TO postgres;

--
-- TOC entry 890 (class 1247 OID 16498)
-- Name: capa_business_impact_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.capa_business_impact_enum AS ENUM (
    'material_waste',
    'production_stoppage',
    'customer_rejection',
    'legal_risk',
    'other'
);


ALTER TYPE public.capa_business_impact_enum OWNER TO postgres;

--
-- TOC entry 884 (class 1247 OID 16478)
-- Name: capa_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.capa_status_enum AS ENUM (
    'open',
    'in_progress',
    'verified',
    'closed',
    'reopened'
);


ALTER TYPE public.capa_status_enum OWNER TO postgres;

--
-- TOC entry 887 (class 1247 OID 16490)
-- Name: effectiveness_score_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.effectiveness_score_enum AS ENUM (
    'effective',
    'partially_effective',
    'ineffective'
);


ALTER TYPE public.effectiveness_score_enum OWNER TO postgres;

--
-- TOC entry 863 (class 1247 OID 16402)
-- Name: ncr_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.ncr_type_enum AS ENUM (
    'Product',
    'Process',
    'System',
    'Supplier'
);


ALTER TYPE public.ncr_type_enum OWNER TO postgres;

--
-- TOC entry 893 (class 1247 OID 16510)
-- Name: risk_level_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.risk_level_enum AS ENUM (
    'Low',
    'Medium',
    'High',
    'Critical'
);


ALTER TYPE public.risk_level_enum OWNER TO postgres;

--
-- TOC entry 881 (class 1247 OID 16473)
-- Name: risk_score_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.risk_score_enum AS ENUM (
    'above_threshold',
    'below_threshold'
);


ALTER TYPE public.risk_score_enum OWNER TO postgres;

--
-- TOC entry 872 (class 1247 OID 16432)
-- Name: root_cause_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.root_cause_type_enum AS ENUM (
    'systemic',
    'non-systemic'
);


ALTER TYPE public.root_cause_type_enum OWNER TO postgres;

--
-- TOC entry 866 (class 1247 OID 16412)
-- Name: severity_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.severity_enum AS ENUM (
    'Low',
    'Medium',
    'High',
    'Critical'
);


ALTER TYPE public.severity_enum OWNER TO postgres;

--
-- TOC entry 875 (class 1247 OID 16438)
-- Name: six_m_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.six_m_enum AS ENUM (
    'Man',
    'Machine',
    'Material',
    'Method',
    'Measurement',
    'Environment'
);


ALTER TYPE public.six_m_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 230 (class 1259 OID 16632)
-- Name: audit_trail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_trail (
    audit_id integer NOT NULL,
    entity_type character varying(30) NOT NULL,
    entity_id integer NOT NULL,
    action text NOT NULL,
    old_value jsonb,
    new_value jsonb,
    performed_by integer NOT NULL,
    performed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    repeat_reference_id integer,
    repeat_flagged_by integer,
    risk_score_snapshot integer,
    capa_effectiveness_snapshot public.effectiveness_score_enum,
    sop_update_flag boolean DEFAULT false,
    qms_update_flag boolean DEFAULT false
);


ALTER TABLE public.audit_trail OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16631)
-- Name: audit_trail_audit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.audit_trail_audit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audit_trail_audit_id_seq OWNER TO postgres;

--
-- TOC entry 5103 (class 0 OID 0)
-- Dependencies: 229
-- Name: audit_trail_audit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.audit_trail_audit_id_seq OWNED BY public.audit_trail.audit_id;


--
-- TOC entry 222 (class 1259 OID 16520)
-- Name: capa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.capa (
    capa_id integer NOT NULL,
    ncr_id integer NOT NULL,
    root_cause text NOT NULL,
    root_cause_type public.root_cause_type_enum NOT NULL,
    risk_score public.risk_score_enum NOT NULL,
    corrective_action text NOT NULL,
    preventive_action text,
    capa_start_date timestamp without time zone NOT NULL,
    planned_finish_date timestamp without time zone NOT NULL,
    actual_finish_date timestamp without time zone,
    department_owner integer,
    assigned_to integer,
    effectiveness_review text,
    effectiveness_review_measure text,
    effectiveness_score public.effectiveness_score_enum NOT NULL,
    status public.capa_status_enum NOT NULL,
    is_repeat boolean DEFAULT false,
    previous_capa_id integer,
    reuse_docs_links jsonb,
    business_impact public.capa_business_impact_enum NOT NULL,
    cost_impact numeric(12,2) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.capa OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16519)
-- Name: capa_capa_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.capa_capa_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.capa_capa_id_seq OWNER TO postgres;

--
-- TOC entry 5104 (class 0 OID 0)
-- Dependencies: 221
-- Name: capa_capa_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.capa_capa_id_seq OWNED BY public.capa.capa_id;


--
-- TOC entry 224 (class 1259 OID 16549)
-- Name: fmea; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fmea (
    fmea_id integer NOT NULL,
    rev_no character varying(10) NOT NULL,
    process_name character varying(150) NOT NULL,
    process_step character varying(150) NOT NULL,
    function text NOT NULL,
    failure_mode text NOT NULL,
    failure_effect text NOT NULL,
    failure_cause text NOT NULL,
    severity integer NOT NULL,
    occurrence integer NOT NULL,
    detection integer NOT NULL,
    rpn integer NOT NULL,
    current_controls text NOT NULL,
    recommended_action text NOT NULL,
    action_owner character varying(100) NOT NULL,
    due_date date NOT NULL,
    action_taken text NOT NULL,
    revised_severity integer NOT NULL,
    revised_occurrence integer NOT NULL,
    revised_detection integer NOT NULL,
    revised_rpn integer NOT NULL,
    evidence text,
    linked_risk_id integer,
    linked_capa_id integer
);


ALTER TABLE public.fmea OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16548)
-- Name: fmea_fmea_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fmea_fmea_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fmea_fmea_id_seq OWNER TO postgres;

--
-- TOC entry 5105 (class 0 OID 0)
-- Dependencies: 223
-- Name: fmea_fmea_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fmea_fmea_id_seq OWNED BY public.fmea.fmea_id;


--
-- TOC entry 220 (class 1259 OID 16452)
-- Name: ncr; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ncr (
    ncr_id integer NOT NULL,
    issue_id integer NOT NULL,
    ncr_number character varying(50) NOT NULL,
    ncr_description text NOT NULL,
    ncr_type public.ncr_type_enum NOT NULL,
    severity_level public.severity_enum NOT NULL,
    business_impact public.business_impact_enum NOT NULL,
    cost_impact numeric(12,2) NOT NULL,
    department_owner integer,
    assigned_to integer,
    containment_action text,
    root_cause_summary text,
    root_cause_type public.root_cause_type_enum,
    six_m_category public.six_m_enum,
    linked_capa_id integer,
    is_repeat_issue boolean DEFAULT false,
    previous_ncr_reference integer,
    previous_capa_id integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.ncr OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16451)
-- Name: ncr_ncr_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ncr_ncr_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ncr_ncr_id_seq OWNER TO postgres;

--
-- TOC entry 5106 (class 0 OID 0)
-- Dependencies: 219
-- Name: ncr_ncr_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ncr_ncr_id_seq OWNED BY public.ncr.ncr_id;


--
-- TOC entry 226 (class 1259 OID 16579)
-- Name: risk_matrix; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.risk_matrix (
    risk_id integer NOT NULL,
    risk_title character varying(150) NOT NULL,
    risk_description text NOT NULL,
    source character varying(50) NOT NULL,
    severity integer NOT NULL,
    likelihood integer NOT NULL,
    risk_score integer NOT NULL,
    risk_level public.risk_level_enum NOT NULL,
    existing_controls text NOT NULL,
    residual_risk_score integer NOT NULL,
    residual_risk_level public.risk_level_enum NOT NULL,
    owner character varying(100) NOT NULL,
    review_frequency character varying(50) NOT NULL,
    next_review_date date NOT NULL,
    linked_fmea_ids character varying(255),
    linked_risk_register_id integer,
    linked_capa_id integer,
    status character varying(20) NOT NULL,
    last_review_date date,
    evidence text
);


ALTER TABLE public.risk_matrix OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16578)
-- Name: risk_matrix_risk_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.risk_matrix_risk_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.risk_matrix_risk_id_seq OWNER TO postgres;

--
-- TOC entry 5107 (class 0 OID 0)
-- Dependencies: 225
-- Name: risk_matrix_risk_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.risk_matrix_risk_id_seq OWNED BY public.risk_matrix.risk_id;


--
-- TOC entry 228 (class 1259 OID 16603)
-- Name: risk_register; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.risk_register (
    risk_register_id integer NOT NULL,
    risk_title character varying(150) NOT NULL,
    risk_description text NOT NULL,
    source character varying(50) NOT NULL,
    initial_severity integer NOT NULL,
    initial_likelihood integer NOT NULL,
    initial_score integer NOT NULL,
    initial_risk_level public.risk_level_enum NOT NULL,
    existing_controls text NOT NULL,
    action_owner character varying(100) NOT NULL,
    owner_department text NOT NULL,
    action_plan text NOT NULL,
    action_due_date date NOT NULL,
    residual_severity integer NOT NULL,
    residual_likelihood integer NOT NULL,
    residual_score integer NOT NULL,
    residual_risk_level public.risk_level_enum NOT NULL,
    status character varying(20) NOT NULL,
    linked_fmea_id integer,
    linked_risk_matrix_id integer,
    linked_capa_id integer,
    last_review_date date NOT NULL,
    next_review_date date NOT NULL,
    evidence text,
    comments text
);


ALTER TABLE public.risk_register OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16602)
-- Name: risk_register_risk_register_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.risk_register_risk_register_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.risk_register_risk_register_id_seq OWNER TO postgres;

--
-- TOC entry 5108 (class 0 OID 0)
-- Dependencies: 227
-- Name: risk_register_risk_register_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.risk_register_risk_register_id_seq OWNED BY public.risk_register.risk_register_id;


--
-- TOC entry 4922 (class 2604 OID 16635)
-- Name: audit_trail audit_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_trail ALTER COLUMN audit_id SET DEFAULT nextval('public.audit_trail_audit_id_seq'::regclass);


--
-- TOC entry 4915 (class 2604 OID 16523)
-- Name: capa capa_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.capa ALTER COLUMN capa_id SET DEFAULT nextval('public.capa_capa_id_seq'::regclass);


--
-- TOC entry 4919 (class 2604 OID 16552)
-- Name: fmea fmea_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fmea ALTER COLUMN fmea_id SET DEFAULT nextval('public.fmea_fmea_id_seq'::regclass);


--
-- TOC entry 4911 (class 2604 OID 16455)
-- Name: ncr ncr_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ncr ALTER COLUMN ncr_id SET DEFAULT nextval('public.ncr_ncr_id_seq'::regclass);


--
-- TOC entry 4920 (class 2604 OID 16582)
-- Name: risk_matrix risk_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.risk_matrix ALTER COLUMN risk_id SET DEFAULT nextval('public.risk_matrix_risk_id_seq'::regclass);


--
-- TOC entry 4921 (class 2604 OID 16606)
-- Name: risk_register risk_register_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.risk_register ALTER COLUMN risk_register_id SET DEFAULT nextval('public.risk_register_risk_register_id_seq'::regclass);


--
-- TOC entry 5097 (class 0 OID 16632)
-- Dependencies: 230
-- Data for Name: audit_trail; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_trail (audit_id, entity_type, entity_id, action, old_value, new_value, performed_by, performed_at, repeat_reference_id, repeat_flagged_by, risk_score_snapshot, capa_effectiveness_snapshot, sop_update_flag, qms_update_flag) FROM stdin;
\.


--
-- TOC entry 5089 (class 0 OID 16520)
-- Dependencies: 222
-- Data for Name: capa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.capa (capa_id, ncr_id, root_cause, root_cause_type, risk_score, corrective_action, preventive_action, capa_start_date, planned_finish_date, actual_finish_date, department_owner, assigned_to, effectiveness_review, effectiveness_review_measure, effectiveness_score, status, is_repeat, previous_capa_id, reuse_docs_links, business_impact, cost_impact, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5091 (class 0 OID 16549)
-- Dependencies: 224
-- Data for Name: fmea; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fmea (fmea_id, rev_no, process_name, process_step, function, failure_mode, failure_effect, failure_cause, severity, occurrence, detection, rpn, current_controls, recommended_action, action_owner, due_date, action_taken, revised_severity, revised_occurrence, revised_detection, revised_rpn, evidence, linked_risk_id, linked_capa_id) FROM stdin;
\.


--
-- TOC entry 5087 (class 0 OID 16452)
-- Dependencies: 220
-- Data for Name: ncr; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ncr (ncr_id, issue_id, ncr_number, ncr_description, ncr_type, severity_level, business_impact, cost_impact, department_owner, assigned_to, containment_action, root_cause_summary, root_cause_type, six_m_category, linked_capa_id, is_repeat_issue, previous_ncr_reference, previous_capa_id, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5093 (class 0 OID 16579)
-- Dependencies: 226
-- Data for Name: risk_matrix; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.risk_matrix (risk_id, risk_title, risk_description, source, severity, likelihood, risk_score, risk_level, existing_controls, residual_risk_score, residual_risk_level, owner, review_frequency, next_review_date, linked_fmea_ids, linked_risk_register_id, linked_capa_id, status, last_review_date, evidence) FROM stdin;
\.


--
-- TOC entry 5095 (class 0 OID 16603)
-- Dependencies: 228
-- Data for Name: risk_register; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.risk_register (risk_register_id, risk_title, risk_description, source, initial_severity, initial_likelihood, initial_score, initial_risk_level, existing_controls, action_owner, owner_department, action_plan, action_due_date, residual_severity, residual_likelihood, residual_score, residual_risk_level, status, linked_fmea_id, linked_risk_matrix_id, linked_capa_id, last_review_date, next_review_date, evidence, comments) FROM stdin;
\.


--
-- TOC entry 5109 (class 0 OID 0)
-- Dependencies: 229
-- Name: audit_trail_audit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.audit_trail_audit_id_seq', 1, false);


--
-- TOC entry 5110 (class 0 OID 0)
-- Dependencies: 221
-- Name: capa_capa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.capa_capa_id_seq', 1, false);


--
-- TOC entry 5111 (class 0 OID 0)
-- Dependencies: 223
-- Name: fmea_fmea_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fmea_fmea_id_seq', 1, false);


--
-- TOC entry 5112 (class 0 OID 0)
-- Dependencies: 219
-- Name: ncr_ncr_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ncr_ncr_id_seq', 1, false);


--
-- TOC entry 5113 (class 0 OID 0)
-- Dependencies: 225
-- Name: risk_matrix_risk_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.risk_matrix_risk_id_seq', 1, false);


--
-- TOC entry 5114 (class 0 OID 0)
-- Dependencies: 227
-- Name: risk_register_risk_register_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.risk_register_risk_register_id_seq', 1, false);


--
-- TOC entry 4937 (class 2606 OID 16647)
-- Name: audit_trail audit_trail_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_trail
    ADD CONSTRAINT audit_trail_pkey PRIMARY KEY (audit_id);


--
-- TOC entry 4929 (class 2606 OID 16542)
-- Name: capa capa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.capa
    ADD CONSTRAINT capa_pkey PRIMARY KEY (capa_id);


--
-- TOC entry 4931 (class 2606 OID 16577)
-- Name: fmea fmea_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fmea
    ADD CONSTRAINT fmea_pkey PRIMARY KEY (fmea_id);


--
-- TOC entry 4927 (class 2606 OID 16470)
-- Name: ncr ncr_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ncr
    ADD CONSTRAINT ncr_pkey PRIMARY KEY (ncr_id);


--
-- TOC entry 4933 (class 2606 OID 16601)
-- Name: risk_matrix risk_matrix_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.risk_matrix
    ADD CONSTRAINT risk_matrix_pkey PRIMARY KEY (risk_id);


--
-- TOC entry 4935 (class 2606 OID 16630)
-- Name: risk_register risk_register_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.risk_register
    ADD CONSTRAINT risk_register_pkey PRIMARY KEY (risk_register_id);


--
-- TOC entry 4938 (class 2606 OID 16543)
-- Name: capa capa_ncr_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.capa
    ADD CONSTRAINT capa_ncr_id_fkey FOREIGN KEY (ncr_id) REFERENCES public.ncr(ncr_id);


-- Completed on 2026-02-20 20:08:34

--
-- PostgreSQL database dump complete
--

\unrestrict ynofwkyRvIQVoJnZzwYwWzak5nTc46k30oUmsTZqgS7tHGkaMqXZLBC7ueO8TPo

