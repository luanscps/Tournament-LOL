--
-- PostgreSQL database dump
--

\restrict q2NHpilvUIYschoZHPktvxDpcbG10hukebo8OtLF6jQ3wxlVsTkqwrQTydBVT8z

-- Dumped from database version 17.6
-- Dumped by pg_dump version 18.3

-- Started on 2026-04-26 21:49:49

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
-- TOC entry 39 (class 2615 OID 16498)
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- TOC entry 25 (class 2615 OID 16392)
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- TOC entry 37 (class 2615 OID 16578)
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- TOC entry 36 (class 2615 OID 16567)
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- TOC entry 8 (class 3079 OID 18349)
-- Name: pg_net; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_net WITH SCHEMA extensions;


--
-- TOC entry 4967 (class 0 OID 0)
-- Dependencies: 8
-- Name: EXTENSION pg_net; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_net IS 'Async HTTP';


--
-- TOC entry 14 (class 2615 OID 16390)
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- TOC entry 16 (class 2615 OID 16559)
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- TOC entry 40 (class 2615 OID 16546)
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- TOC entry 71 (class 2615 OID 18256)
-- Name: supabase_migrations; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA supabase_migrations;


ALTER SCHEMA supabase_migrations OWNER TO postgres;

--
-- TOC entry 34 (class 2615 OID 16607)
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- TOC entry 2 (class 3079 OID 16393)
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- TOC entry 4973 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- TOC entry 6 (class 3079 OID 17551)
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- TOC entry 4974 (class 0 OID 0)
-- Dependencies: 6
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- TOC entry 4 (class 3079 OID 16447)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- TOC entry 4975 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- TOC entry 5 (class 3079 OID 16608)
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- TOC entry 4976 (class 0 OID 0)
-- Dependencies: 5
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- TOC entry 7 (class 3079 OID 18324)
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA extensions;


--
-- TOC entry 4977 (class 0 OID 0)
-- Dependencies: 7
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


--
-- TOC entry 3 (class 3079 OID 16436)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- TOC entry 4978 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 1235 (class 1247 OID 16742)
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- TOC entry 1259 (class 1247 OID 16883)
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- TOC entry 1232 (class 1247 OID 16736)
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- TOC entry 1229 (class 1247 OID 16730)
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- TOC entry 1277 (class 1247 OID 16986)
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


ALTER TYPE auth.oauth_authorization_status OWNER TO supabase_auth_admin;

--
-- TOC entry 1289 (class 1247 OID 17059)
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


ALTER TYPE auth.oauth_client_type OWNER TO supabase_auth_admin;

--
-- TOC entry 1271 (class 1247 OID 16964)
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


ALTER TYPE auth.oauth_registration_type OWNER TO supabase_auth_admin;

--
-- TOC entry 1280 (class 1247 OID 16996)
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


ALTER TYPE auth.oauth_response_type OWNER TO supabase_auth_admin;

--
-- TOC entry 1265 (class 1247 OID 16925)
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- TOC entry 1360 (class 1247 OID 17644)
-- Name: bracket_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.bracket_type AS ENUM (
    'SINGLE_ELIMINATION',
    'DOUBLE_ELIMINATION',
    'ROUND_ROBIN',
    'SWISS'
);


ALTER TYPE public.bracket_type OWNER TO postgres;

--
-- TOC entry 1414 (class 1247 OID 18180)
-- Name: dispute_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.dispute_status AS ENUM (
    'OPEN',
    'UNDER_REVIEW',
    'RESOLVED',
    'DISMISSED'
);


ALTER TYPE public.dispute_status OWNER TO postgres;

--
-- TOC entry 1366 (class 1247 OID 17662)
-- Name: inscricao_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.inscricao_status AS ENUM (
    'PENDING',
    'APPROVED',
    'REJECTED'
);


ALTER TYPE public.inscricao_status OWNER TO postgres;

--
-- TOC entry 1408 (class 1247 OID 18148)
-- Name: invite_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.invite_status AS ENUM (
    'PENDING',
    'ACCEPTED',
    'DECLINED',
    'EXPIRED'
);


ALTER TYPE public.invite_status OWNER TO postgres;

--
-- TOC entry 1363 (class 1247 OID 17654)
-- Name: match_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.match_status AS ENUM (
    'SCHEDULED',
    'IN_PROGRESS',
    'FINISHED'
);


ALTER TYPE public.match_status OWNER TO postgres;

--
-- TOC entry 1369 (class 1247 OID 17670)
-- Name: player_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.player_role AS ENUM (
    'TOP',
    'JUNGLE',
    'MID',
    'ADC',
    'SUPPORT'
);


ALTER TYPE public.player_role OWNER TO postgres;

--
-- TOC entry 1486 (class 1247 OID 19824)
-- Name: team_member_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.team_member_role AS ENUM (
    'captain',
    'member',
    'substitute'
);


ALTER TYPE public.team_member_role OWNER TO postgres;

--
-- TOC entry 1483 (class 1247 OID 19815)
-- Name: team_member_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.team_member_status AS ENUM (
    'pending',
    'accepted',
    'rejected',
    'left'
);


ALTER TYPE public.team_member_status OWNER TO postgres;

--
-- TOC entry 1357 (class 1247 OID 17633)
-- Name: tournament_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tournament_status AS ENUM (
    'DRAFT',
    'OPEN',
    'IN_PROGRESS',
    'FINISHED',
    'CANCELLED'
);


ALTER TYPE public.tournament_status OWNER TO postgres;

--
-- TOC entry 1480 (class 1247 OID 19805)
-- Name: user_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_role AS ENUM (
    'player',
    'organizer',
    'admin'
);


ALTER TYPE public.user_role OWNER TO postgres;

--
-- TOC entry 1343 (class 1247 OID 17412)
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_admin;

--
-- TOC entry 1334 (class 1247 OID 17372)
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_admin;

--
-- TOC entry 1337 (class 1247 OID 17387)
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_admin;

--
-- TOC entry 1349 (class 1247 OID 17454)
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_admin;

--
-- TOC entry 1346 (class 1247 OID 17425)
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_admin;

--
-- TOC entry 1319 (class 1247 OID 17290)
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


ALTER TYPE storage.buckettype OWNER TO supabase_storage_admin;

--
-- TOC entry 576 (class 1255 OID 16544)
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- TOC entry 4981 (class 0 OID 0)
-- Dependencies: 576
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- TOC entry 561 (class 1255 OID 16712)
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- TOC entry 575 (class 1255 OID 16543)
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- TOC entry 4984 (class 0 OID 0)
-- Dependencies: 575
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- TOC entry 580 (class 1255 OID 16542)
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- TOC entry 4986 (class 0 OID 0)
-- Dependencies: 580
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- TOC entry 571 (class 1255 OID 16551)
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO supabase_admin;

--
-- TOC entry 5002 (class 0 OID 0)
-- Dependencies: 571
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- TOC entry 492 (class 1255 OID 16572)
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- TOC entry 5004 (class 0 OID 0)
-- Dependencies: 492
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- TOC entry 456 (class 1255 OID 16553)
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO supabase_admin;

--
-- TOC entry 5006 (class 0 OID 0)
-- Dependencies: 456
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- TOC entry 421 (class 1255 OID 16563)
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- TOC entry 430 (class 1255 OID 16564)
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- TOC entry 482 (class 1255 OID 16574)
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- TOC entry 5035 (class 0 OID 0)
-- Dependencies: 482
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- TOC entry 546 (class 1255 OID 19935)
-- Name: graphql(text, text, jsonb, jsonb); Type: FUNCTION; Schema: graphql_public; Owner: supabase_admin
--

CREATE FUNCTION graphql_public.graphql("operationName" text DEFAULT NULL::text, query text DEFAULT NULL::text, variables jsonb DEFAULT NULL::jsonb, extensions jsonb DEFAULT NULL::jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;


ALTER FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) OWNER TO supabase_admin;

--
-- TOC entry 432 (class 1255 OID 16391)
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: supabase_admin
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
  BEGIN
      RAISE DEBUG 'PgBouncer auth request: %', p_usename;

      RETURN QUERY
      SELECT
          rolname::text,
          CASE WHEN rolvaliduntil < now()
              THEN null
              ELSE rolpassword::text
          END
      FROM pg_authid
      WHERE rolname=$1 and rolcanlogin;
  END;
  $_$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO supabase_admin;

--
-- TOC entry 443 (class 1255 OID 19920)
-- Name: accept_team_invite(uuid, uuid, uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.accept_team_invite(p_invite_id uuid, p_profile_id uuid, p_riot_acc_id uuid DEFAULT NULL::uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
  v_invite  public.team_invites%rowtype;
  v_role    team_member_role := 'member';
begin
  -- Busca e trava o convite
  select * into v_invite
    from public.team_invites
    where id = p_invite_id
    for update;

  if not found then
    return jsonb_build_object('error', 'Convite não encontrado');
  end if;

  if v_invite.status <> 'PENDING' then
    return jsonb_build_object('error', 'Convite não está mais pendente');
  end if;

  if v_invite.expires_at < now() then
    update public.team_invites set status = 'EXPIRED' where id = p_invite_id;
    return jsonb_build_object('error', 'Convite expirado');
  end if;

  -- Mapeia role do convite para team_member_role
  if v_invite.role is not null then
    v_role := case
      when v_invite.role::text = 'captain' then 'captain'
      else 'member'
    end::team_member_role;
  end if;

  -- Marca convite como aceito
  update public.team_invites
    set status = 'ACCEPTED'
    where id = p_invite_id;

  -- Upsert em team_members
  insert into public.team_members (
    team_id, profile_id, riot_account_id, team_role, status,
    invited_by, invited_at, responded_at
  ) values (
    v_invite.team_id, p_profile_id, p_riot_acc_id, v_role, 'accepted',
    v_invite.invited_by, v_invite.created_at, now()
  )
  on conflict (team_id, profile_id)
    do update set
      status       = 'accepted',
      responded_at = now(),
      team_role    = excluded.team_role;

  -- Define como time ativo do jogador
  insert into public.active_team (profile_id, team_id)
    values (p_profile_id, v_invite.team_id)
    on conflict (profile_id)
      do update set team_id = excluded.team_id, updated_at = now();

  return jsonb_build_object('success', true, 'team_id', v_invite.team_id);
end;
$$;


ALTER FUNCTION public.accept_team_invite(p_invite_id uuid, p_profile_id uuid, p_riot_acc_id uuid) OWNER TO postgres;

--
-- TOC entry 573 (class 1255 OID 18253)
-- Name: audit_matches_changes(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.audit_matches_changes() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    INSERT INTO public.audit_log (admin_id, action, table_name, record_id, old_data, new_data)
    VALUES (auth.uid(), 'UPDATE', 'matches', NEW.id::text, row_to_json(OLD)::jsonb, row_to_json(NEW)::jsonb);
    RETURN NEW;
  ELSIF TG_OP = 'INSERT' THEN
    INSERT INTO public.audit_log (admin_id, action, table_name, record_id, new_data)
    VALUES (auth.uid(), 'INSERT', 'matches', NEW.id::text, row_to_json(NEW)::jsonb);
    RETURN NEW;
  END IF;
  RETURN NULL;
END;
$$;


ALTER FUNCTION public.audit_matches_changes() OWNER TO postgres;

--
-- TOC entry 543 (class 1255 OID 19893)
-- Name: auto_add_captain_as_member(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.auto_add_captain_as_member() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
  v_riot_id uuid;
begin
  -- Busca conta Riot primária do capitão
  select id into v_riot_id
    from public.riot_accounts
    where profile_id = new.owner_id and is_primary = true
    limit 1;

  insert into public.team_members (
    team_id, profile_id, riot_account_id, team_role, status, invited_by, responded_at
  ) values (
    new.id, new.owner_id, v_riot_id, 'captain', 'accepted', new.owner_id, now()
  )
  on conflict (team_id, profile_id) do nothing;

  -- Define como time ativo do capitão
  insert into public.active_team (profile_id, team_id)
    values (new.owner_id, new.id)
    on conflict (profile_id) do update set team_id = excluded.team_id, updated_at = now();

  return new;
end;
$$;


ALTER FUNCTION public.auto_add_captain_as_member() OWNER TO postgres;

--
-- TOC entry 499 (class 1255 OID 18394)
-- Name: call_edge_function(text, jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.call_edge_function(function_name text, payload jsonb) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  supabase_url  text := current_setting('app.supabase_url', true);
  service_key   text := current_setting('app.service_role_key', true);
BEGIN
  PERFORM extensions.http_post(
    url     := supabase_url || '/functions/v1/' || function_name,
    headers := jsonb_build_object(
      'Content-Type',  'application/json',
      'Authorization', 'Bearer ' || service_key
    ),
    body    := payload::text
  );
EXCEPTION WHEN OTHERS THEN
  RAISE WARNING 'call_edge_function(%) falhou: %', function_name, SQLERRM;
END;
$$;


ALTER FUNCTION public.call_edge_function(function_name text, payload jsonb) OWNER TO postgres;

--
-- TOC entry 513 (class 1255 OID 18461)
-- Name: ensure_single_primary_riot_account(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ensure_single_primary_riot_account() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  IF NEW.is_primary THEN
    UPDATE public.riot_accounts
      SET is_primary = false
      WHERE profile_id = NEW.profile_id
        AND id <> COALESCE(NEW.id, '00000000-0000-0000-0000-000000000000'::uuid)
        AND is_primary = true;
  ELSIF TG_OP = 'INSERT' THEN
    IF NOT EXISTS (
      SELECT 1 FROM public.riot_accounts
      WHERE profile_id = NEW.profile_id AND is_primary = true
    ) THEN
      NEW.is_primary := true;
    END IF;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.ensure_single_primary_riot_account() OWNER TO postgres;

--
-- TOC entry 579 (class 1255 OID 19921)
-- Name: expire_pending_invites(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.expire_pending_invites() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
  if new.status = 'PENDING' and new.expires_at < now() then
    new.status := 'EXPIRED';
  end if;
  return new;
end;
$$;


ALTER FUNCTION public.expire_pending_invites() OWNER TO postgres;

--
-- TOC entry 530 (class 1255 OID 19910)
-- Name: fn_notify_inscricao(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_notify_inscricao() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_user_id uuid;
  v_title   text;
  v_body    text;
  v_type    text;
BEGIN
  -- FIX: user_id alvo = quem fez a inscrição (requested_by), não o admin
  v_user_id := COALESCE(NEW.requested_by, OLD.requested_by);

  IF v_user_id IS NULL THEN
    RETURN NEW;
  END IF;

  IF TG_OP = 'INSERT' THEN
    v_type  := 'inscricao_nova';
    v_title := 'Inscrição enviada';
    v_body  := 'Sua inscrição foi recebida e está em análise.';

  ELSIF TG_OP = 'UPDATE' AND OLD.status IS DISTINCT FROM NEW.status THEN
    v_type  := 'inscricao_status';
    CASE NEW.status
      WHEN 'APPROVED' THEN
        v_title := 'Inscrição aprovada! 🎉';
        v_body  := 'Seu time foi aprovado para o torneio.';
      WHEN 'REJECTED' THEN
        v_title := 'Inscrição recusada';
        v_body  := 'Sua inscrição não foi aprovada desta vez.';
      ELSE
        RETURN NEW;
    END CASE;
  ELSE
    RETURN NEW;
  END IF;

  INSERT INTO public.notifications (user_id, type, title, body, metadata)
  VALUES (
    v_user_id,
    v_type,
    v_title,
    v_body,
    jsonb_build_object(
      'tournament_id', NEW.tournament_id,
      'team_id',       NEW.team_id,
      'status',        NEW.status
    )
  );

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.fn_notify_inscricao() OWNER TO postgres;

--
-- TOC entry 493 (class 1255 OID 18321)
-- Name: generate_tournament_slug(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_tournament_slug() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  base_slug text;
  final_slug text;
  counter int := 0;
BEGIN
  -- Remover acentos usando translate (sem dependencia de unaccent)
  base_slug := translate(lower(NEW.name),
    'áàâãäéèêëíìîïóòôõöúùûüçñ',
    'aaaaaeeeeiiiiooooouuuucn'
  );
  
  -- Substituir caracteres nao alfanumericos por hifen
  base_slug := regexp_replace(base_slug, '[^a-z0-9]+', '-', 'g');
  base_slug := trim(both '-' from base_slug);
  
  final_slug := base_slug;
  
  -- Verificar se slug ja existe e adicionar numero se necessario
  WHILE EXISTS (SELECT 1 FROM public.tournaments WHERE slug = final_slug AND id != COALESCE(NEW.id, '00000000-0000-0000-0000-000000000000'::uuid)) LOOP
    counter := counter + 1;
    final_slug := base_slug || '-' || counter;
  END LOOP;
  
  NEW.slug := final_slug;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.generate_tournament_slug() OWNER TO postgres;

--
-- TOC entry 541 (class 1255 OID 17697)
-- Name: handle_new_user(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'extensions'
    AS $$
begin
  insert into public.profiles (id, email, full_name, avatar_url)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data->>'full_name', ''),
    coalesce(new.raw_user_meta_data->>'avatar_url', '')
  ) on conflict (id) do nothing;
  return new;
end;
$$;


ALTER FUNCTION public.handle_new_user() OWNER TO postgres;

--
-- TOC entry 488 (class 1255 OID 18530)
-- Name: has_call_edge_function(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.has_call_edge_function() RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT EXISTS (
    SELECT 1 FROM pg_proc p
    JOIN pg_namespace n ON n.oid = p.pronamespace
    WHERE n.nspname = 'public'
      AND p.proname = 'call_edge_function'
  );
$$;


ALTER FUNCTION public.has_call_edge_function() OWNER TO postgres;

--
-- TOC entry 504 (class 1255 OID 17844)
-- Name: is_admin(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_admin(uid uuid) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
  select coalesce((select role = 'admin' from public.profiles where id = uid), false);
$$;


ALTER FUNCTION public.is_admin(uid uuid) OWNER TO postgres;

--
-- TOC entry 471 (class 1255 OID 18728)
-- Name: is_current_user_admin(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_current_user_admin() RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT COALESCE(
    (SELECT is_admin FROM public.profiles WHERE id = auth.uid() LIMIT 1),
    false
  );
$$;


ALTER FUNCTION public.is_current_user_admin() OWNER TO postgres;

--
-- TOC entry 458 (class 1255 OID 19812)
-- Name: is_organizer_or_admin(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_organizer_or_admin(uid uuid) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
  select coalesce((select role in ('organizer','admin') from public.profiles where id = uid), false);
$$;


ALTER FUNCTION public.is_organizer_or_admin(uid uuid) OWNER TO postgres;

--
-- TOC entry 410 (class 1255 OID 19813)
-- Name: is_tournament_organizer(uuid, uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_tournament_organizer(uid uuid, tid uuid) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
  select exists (
    select 1 from public.tournaments
    where id = tid and (organizer_id = uid or created_by = uid)
  ) or public.is_admin(uid);
$$;


ALTER FUNCTION public.is_tournament_organizer(uid uuid, tid uuid) OWNER TO postgres;

--
-- TOC entry 582 (class 1255 OID 18252)
-- Name: log_admin_action(text, text, text, jsonb, jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.log_admin_action(p_action text, p_table_name text, p_record_id text DEFAULT NULL::text, p_old_data jsonb DEFAULT NULL::jsonb, p_new_data jsonb DEFAULT NULL::jsonb) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  INSERT INTO public.audit_log (admin_id, action, table_name, record_id, old_data, new_data)
  VALUES (auth.uid(), p_action, p_table_name, p_record_id, p_old_data, p_new_data);
END;
$$;


ALTER FUNCTION public.log_admin_action(p_action text, p_table_name text, p_record_id text, p_old_data jsonb, p_new_data jsonb) OWNER TO postgres;

--
-- TOC entry 444 (class 1255 OID 17839)
-- Name: set_updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public'
    AS $$
begin
  new.updated_at = now();
  return new;
end;
$$;


ALTER FUNCTION public.set_updated_at() OWNER TO postgres;

--
-- TOC entry 483 (class 1255 OID 18522)
-- Name: sync_notifications_body_message(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sync_notifications_body_message() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  IF NEW.body IS NULL AND NEW.message IS NOT NULL THEN
    NEW.body := NEW.message;
  END IF;
  IF NEW.message IS NULL AND NEW.body IS NOT NULL THEN
    NEW.message := NEW.body;
  END IF;
  IF NEW.body IS NOT NULL AND NEW.message IS DISTINCT FROM NEW.body THEN
    NEW.message := NEW.body;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sync_notifications_body_message() OWNER TO postgres;

--
-- TOC entry 509 (class 1255 OID 18395)
-- Name: trg_inscricao_nova(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_inscricao_nova() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_team_name text;
  v_tournament_name text;
  v_captain_name text;
  v_captain_email text;
BEGIN
  IF NEW.status <> 'PENDING' THEN RETURN NEW; END IF;

  SELECT t.name INTO v_team_name FROM public.teams t WHERE t.id = NEW.team_id;
  SELECT tr.name INTO v_tournament_name FROM public.tournaments tr WHERE tr.id = NEW.tournament_id;

  IF NEW.requested_by IS NOT NULL THEN
    SELECT p.full_name, p.email INTO v_captain_name, v_captain_email
    FROM public.profiles p WHERE p.id = NEW.requested_by;

    INSERT INTO public.notifications (
      id, user_id, type, title, body, message, metadata, read, created_at
    ) VALUES (
      gen_random_uuid(),
      NEW.requested_by,
      'registration_update',
      'Inscrição recebida',
      format('A inscrição do time %s foi registrada no torneio %s.', COALESCE(v_team_name, 'Time'), COALESCE(v_tournament_name, 'Torneio')),
      format('A inscrição do time %s foi registrada no torneio %s.', COALESCE(v_team_name, 'Time'), COALESCE(v_tournament_name, 'Torneio')),
      jsonb_build_object('team_id', NEW.team_id, 'tournament_id', NEW.tournament_id, 'status', NEW.status),
      false,
      now()
    );

    IF public.has_call_edge_function() AND v_captain_email IS NOT NULL THEN
      PERFORM public.call_edge_function(
        'send-email',
        jsonb_build_object(
          'template', 'inscricao_pendente',
          'data', jsonb_build_object(
            'to_email', v_captain_email,
            'captain_name', COALESCE(v_captain_name, 'Capitão'),
            'team_name', COALESCE(v_team_name, 'Time'),
            'tournament_name', COALESCE(v_tournament_name, 'Torneio')
          )
        )
      );
    END IF;
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.trg_inscricao_nova() OWNER TO postgres;

--
-- TOC entry 569 (class 1255 OID 18397)
-- Name: trg_inscricao_status_change(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_inscricao_status_change() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_team_name text;
  v_tournament_name text;
  v_captain_name text;
  v_captain_email text;
  v_notification_title text;
  v_notification_body text;
  v_email_template text;
  v_discord_type text;
BEGIN
  IF NEW.status IS NOT DISTINCT FROM OLD.status THEN RETURN NEW; END IF;
  IF NEW.status NOT IN ('APPROVED', 'REJECTED') THEN RETURN NEW; END IF;

  SELECT t.name INTO v_team_name FROM public.teams t WHERE t.id = NEW.team_id;
  SELECT tr.name INTO v_tournament_name FROM public.tournaments tr WHERE tr.id = NEW.tournament_id;

  IF NEW.requested_by IS NOT NULL THEN
    SELECT p.full_name, p.email INTO v_captain_name, v_captain_email
    FROM public.profiles p WHERE p.id = NEW.requested_by;
  END IF;

  IF NEW.status = 'APPROVED' THEN
    v_notification_title := 'Inscrição aprovada';
    v_notification_body := format('O time %s foi aprovado no torneio %s.', COALESCE(v_team_name, 'Time'), COALESCE(v_tournament_name, 'Torneio'));
    v_email_template := 'inscricao_aprovada';
    v_discord_type := 'inscricao_aprovada';
  ELSE
    v_notification_title := 'Inscrição rejeitada';
    v_notification_body := format('O time %s não foi aprovado no torneio %s.', COALESCE(v_team_name, 'Time'), COALESCE(v_tournament_name, 'Torneio'));
    v_email_template := 'inscricao_rejeitada';
    v_discord_type := 'inscricao_rejeitada';
  END IF;

  IF NEW.requested_by IS NOT NULL THEN
    INSERT INTO public.notifications (
      id, user_id, type, title, body, message, metadata, read, created_at
    ) VALUES (
      uuid_generate_v4(),
      NEW.requested_by,
      'registration_update',
      v_notification_title,
      v_notification_body,
      v_notification_body,
      jsonb_build_object('team_id', NEW.team_id, 'tournament_id', NEW.tournament_id, 'status', NEW.status, 'notes', NEW.notes),
      false,
      now()
    );

    IF public.has_call_edge_function() AND v_captain_email IS NOT NULL THEN
      PERFORM public.call_edge_function(
        'send-email',
        jsonb_build_object(
          'template', v_email_template,
          'data', jsonb_build_object(
            'to_email', v_captain_email,
            'captain_name', COALESCE(v_captain_name, 'Capitão'),
            'team_name', COALESCE(v_team_name, 'Time'),
            'tournament_name', COALESCE(v_tournament_name, 'Torneio'),
            'reason', NEW.notes
          )
        )
      );
    END IF;
  END IF;

  IF public.has_call_edge_function() THEN
    PERFORM public.call_edge_function(
      'discord-webhook',
      jsonb_build_object(
        'type', v_discord_type,
        'tournament_id', NEW.tournament_id::text,
        'data', jsonb_build_object(
          'team_name', COALESCE(v_team_name, 'Time'),
          'tournament_name', COALESCE(v_tournament_name, 'Torneio')
        )
      )
    );
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.trg_inscricao_status_change() OWNER TO postgres;

--
-- TOC entry 420 (class 1255 OID 18399)
-- Name: trg_match_finished(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_match_finished() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_team_a_name text;
  v_team_b_name text;
  v_winner_name text;
  v_tournament_name text;
  v_score_a integer := 0;
  v_score_b integer := 0;
BEGIN
  IF NEW.status IS NOT DISTINCT FROM OLD.status THEN RETURN NEW; END IF;
  IF NEW.status <> 'FINISHED' THEN RETURN NEW; END IF;

  SELECT name INTO v_team_a_name FROM public.teams WHERE id = NEW.team_a_id;
  SELECT name INTO v_team_b_name FROM public.teams WHERE id = NEW.team_b_id;
  SELECT name INTO v_winner_name FROM public.teams WHERE id = NEW.winner_id;
  SELECT name INTO v_tournament_name FROM public.tournaments WHERE id = NEW.tournament_id;

  IF NEW.score_a IS NOT NULL AND NEW.score_b IS NOT NULL THEN
    v_score_a := NEW.score_a;
    v_score_b := NEW.score_b;
  ELSE
    SELECT
      COUNT(*) FILTER (WHERE mg.winner_id = NEW.team_a_id),
      COUNT(*) FILTER (WHERE mg.winner_id = NEW.team_b_id)
    INTO v_score_a, v_score_b
    FROM public.match_games mg
    WHERE mg.match_id = NEW.id;
  END IF;

  IF public.has_call_edge_function() THEN
    PERFORM public.call_edge_function(
      'discord-webhook',
      jsonb_build_object(
        'type', 'partida_finalizada',
        'tournament_id', NEW.tournament_id::text,
        'data', jsonb_build_object(
          'team_a', COALESCE(v_team_a_name, 'Time A'),
          'team_b', COALESCE(v_team_b_name, 'Time B'),
          'score_a', COALESCE(v_score_a, 0),
          'score_b', COALESCE(v_score_b, 0),
          'winner', COALESCE(v_winner_name, 'A definir'),
          'tournament_name', COALESCE(v_tournament_name, 'Torneio'),
          'format', COALESCE(NEW.format::text, 'BO1')
        )
      )
    );
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.trg_match_finished() OWNER TO postgres;

--
-- TOC entry 447 (class 1255 OID 18401)
-- Name: trg_tournament_started(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_tournament_started() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_team_count integer := 0;
BEGIN
  IF NEW.status IS NOT DISTINCT FROM OLD.status THEN RETURN NEW; END IF;
  IF NEW.status <> 'IN_PROGRESS' THEN RETURN NEW; END IF;

  SELECT COUNT(*) INTO v_team_count
  FROM public.inscricoes i
  WHERE i.tournament_id = NEW.id AND i.status = 'APPROVED';

  IF public.has_call_edge_function() THEN
    PERFORM public.call_edge_function(
      'discord-webhook',
      jsonb_build_object(
        'type', 'torneio_iniciado',
        'tournament_id', NEW.id::text,
        'data', jsonb_build_object(
          'tournament_name', NEW.name,
          'team_count', v_team_count,
          'bracket_type', NEW.bracket_type::text
        )
      )
    );
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.trg_tournament_started() OWNER TO postgres;

--
-- TOC entry 549 (class 1255 OID 17447)
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_
        -- Filter by action early - only get subscriptions interested in this action
        -- action_filter column can be: '*' (all), 'INSERT', 'UPDATE', or 'DELETE'
        and (subs.action_filter = '*' or subs.action_filter = action::text);

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_admin;

--
-- TOC entry 416 (class 1255 OID 17526)
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_admin;

--
-- TOC entry 544 (class 1255 OID 17459)
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_admin;

--
-- TOC entry 480 (class 1255 OID 17409)
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
declare
  res jsonb;
begin
  if type_::text = 'bytea' then
    return to_jsonb(val);
  end if;
  execute format('select to_jsonb(%L::'|| type_::text || ')', val) into res;
  return res;
end
$$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_admin;

--
-- TOC entry 413 (class 1255 OID 17404)
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_admin;

--
-- TOC entry 510 (class 1255 OID 17455)
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_admin;

--
-- TOC entry 479 (class 1255 OID 17550)
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS TABLE(wal jsonb, is_rls_enabled boolean, subscription_ids uuid[], errors text[], slot_changes_count bigint)
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
  WITH pub AS (
    SELECT
      concat_ws(
        ',',
        CASE WHEN bool_or(pubinsert) THEN 'insert' ELSE NULL END,
        CASE WHEN bool_or(pubupdate) THEN 'update' ELSE NULL END,
        CASE WHEN bool_or(pubdelete) THEN 'delete' ELSE NULL END
      ) AS w2j_actions,
      coalesce(
        string_agg(
          realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
          ','
        ) filter (WHERE ppt.tablename IS NOT NULL AND ppt.tablename NOT LIKE '% %'),
        ''
      ) AS w2j_add_tables
    FROM pg_publication pp
    LEFT JOIN pg_publication_tables ppt ON pp.pubname = ppt.pubname
    WHERE pp.pubname = publication
    GROUP BY pp.pubname
    LIMIT 1
  ),
  -- MATERIALIZED ensures pg_logical_slot_get_changes is called exactly once
  w2j AS MATERIALIZED (
    SELECT x.*, pub.w2j_add_tables
    FROM pub,
         pg_logical_slot_get_changes(
           slot_name, null, max_changes,
           'include-pk', 'true',
           'include-transaction', 'false',
           'include-timestamp', 'true',
           'include-type-oids', 'true',
           'format-version', '2',
           'actions', pub.w2j_actions,
           'add-tables', pub.w2j_add_tables
         ) x
  ),
  -- Count raw slot entries before apply_rls/subscription filter
  slot_count AS (
    SELECT count(*)::bigint AS cnt
    FROM w2j
    WHERE w2j.w2j_add_tables <> ''
  ),
  -- Apply RLS and filter as before
  rls_filtered AS (
    SELECT xyz.wal, xyz.is_rls_enabled, xyz.subscription_ids, xyz.errors
    FROM w2j,
         realtime.apply_rls(
           wal := w2j.data::jsonb,
           max_record_bytes := max_record_bytes
         ) xyz(wal, is_rls_enabled, subscription_ids, errors)
    WHERE w2j.w2j_add_tables <> ''
      AND xyz.subscription_ids[1] IS NOT NULL
  )
  -- Real rows with slot count attached
  SELECT rf.wal, rf.is_rls_enabled, rf.subscription_ids, rf.errors, sc.cnt
  FROM rls_filtered rf, slot_count sc

  UNION ALL

  -- Sentinel row: always returned when no real rows exist so Elixir can
  -- always read slot_changes_count. Identified by wal IS NULL.
  SELECT null, null, null, null, sc.cnt
  FROM slot_count sc
  WHERE NOT EXISTS (SELECT 1 FROM rls_filtered)
$$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_admin;

--
-- TOC entry 478 (class 1255 OID 17403)
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_admin;

--
-- TOC entry 408 (class 1255 OID 17525)
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    -- Generate a new UUID for the id
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_admin;

--
-- TOC entry 442 (class 1255 OID 17401)
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_admin;

--
-- TOC entry 526 (class 1255 OID 17436)
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_admin;

--
-- TOC entry 540 (class 1255 OID 17519)
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- TOC entry 558 (class 1255 OID 17356)
-- Name: allow_any_operation(text[]); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.allow_any_operation(expected_operations text[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT CASE
      WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
      ELSE raw_operation
    END AS current_operation
    FROM current_operation
  )
  SELECT EXISTS (
    SELECT 1
    FROM normalized n
    CROSS JOIN LATERAL unnest(expected_operations) AS expected_operation
    WHERE expected_operation IS NOT NULL
      AND expected_operation <> ''
      AND n.current_operation = CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END
  );
$$;


ALTER FUNCTION storage.allow_any_operation(expected_operations text[]) OWNER TO supabase_storage_admin;

--
-- TOC entry 511 (class 1255 OID 17355)
-- Name: allow_only_operation(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.allow_only_operation(expected_operation text) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT
      CASE
        WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
        ELSE raw_operation
      END AS current_operation,
      CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END AS requested_operation
    FROM current_operation
  )
  SELECT CASE
    WHEN requested_operation IS NULL OR requested_operation = '' THEN FALSE
    ELSE COALESCE(current_operation = requested_operation, FALSE)
  END
  FROM normalized;
$$;


ALTER FUNCTION storage.allow_only_operation(expected_operation text) OWNER TO supabase_storage_admin;

--
-- TOC entry 476 (class 1255 OID 17231)
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- TOC entry 440 (class 1255 OID 17287)
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


ALTER FUNCTION storage.enforce_bucket_name_length() OWNER TO supabase_storage_admin;

--
-- TOC entry 446 (class 1255 OID 17206)
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
	select string_to_array(name, '/') into _parts;
	select _parts[array_length(_parts,1)] into _filename;
	-- @todo return the last part instead of 2
	return reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- TOC entry 437 (class 1255 OID 17205)
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- TOC entry 521 (class 1255 OID 17204)
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[1:array_length(_parts,1)-1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- TOC entry 550 (class 1255 OID 17344)
-- Name: get_common_prefix(text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT CASE
    WHEN position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)) > 0
    THEN left(p_key, length(p_prefix) + position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)))
    ELSE NULL
END;
$$;


ALTER FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) OWNER TO supabase_storage_admin;

--
-- TOC entry 475 (class 1255 OID 17218)
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- TOC entry 424 (class 1255 OID 17270)
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO supabase_storage_admin;

--
-- TOC entry 427 (class 1255 OID 17345)
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;

    -- Configuration
    v_is_asc BOOLEAN;
    v_prefix TEXT;
    v_start TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_is_asc := lower(coalesce(sort_order, 'asc')) = 'asc';
    v_prefix := coalesce(prefix_param, '');
    v_start := CASE WHEN coalesce(next_token, '') <> '' THEN next_token ELSE coalesce(start_after, '') END;
    v_file_batch_size := LEAST(GREATEST(max_keys * 2, 100), 1000);

    -- Calculate upper bound for prefix filtering (bytewise, using COLLATE "C")
    IF v_prefix = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix, 1) = delimiter_param THEN
        v_upper_bound := left(v_prefix, -1) || chr(ascii(delimiter_param) + 1);
    ELSE
        v_upper_bound := left(v_prefix, -1) || chr(ascii(right(v_prefix, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'AND o.name COLLATE "C" < $3 ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'AND o.name COLLATE "C" >= $3 ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- ========================================================================
    -- SEEK INITIALIZATION: Determine starting position
    -- ========================================================================
    IF v_start = '' THEN
        IF v_is_asc THEN
            v_next_seek := v_prefix;
        ELSE
            -- DESC without cursor: find the last item in range
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;

            IF v_next_seek IS NOT NULL THEN
                v_next_seek := v_next_seek || delimiter_param;
            ELSE
                RETURN;
            END IF;
        END IF;
    ELSE
        -- Cursor provided: determine if it refers to a folder or leaf
        IF EXISTS (
            SELECT 1 FROM storage.objects o
            WHERE o.bucket_id = _bucket_id
              AND o.name COLLATE "C" LIKE v_start || delimiter_param || '%'
            LIMIT 1
        ) THEN
            -- Cursor refers to a folder
            IF v_is_asc THEN
                v_next_seek := v_start || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_start || delimiter_param;
            END IF;
        ELSE
            -- Cursor refers to a leaf object
            IF v_is_asc THEN
                v_next_seek := v_start || delimiter_param;
            ELSE
                v_next_seek := v_start;
            END IF;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= max_keys;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(v_peek_name, v_prefix, delimiter_param);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Emit and skip to next folder (no heap access needed)
            name := rtrim(v_common_prefix, delimiter_param);
            id := NULL;
            updated_at := NULL;
            created_at := NULL;
            last_accessed_at := NULL;
            metadata := NULL;
            RETURN NEXT;
            v_count := v_count + 1;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := left(v_common_prefix, -1) || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_common_prefix;
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query USING _bucket_id, v_next_seek,
                CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(v_current.name, v_prefix, delimiter_param);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := v_current.name;
                    EXIT;
                END IF;

                -- Emit file
                name := v_current.name;
                id := v_current.id;
                updated_at := v_current.updated_at;
                created_at := v_current.created_at;
                last_accessed_at := v_current.last_accessed_at;
                metadata := v_current.metadata;
                RETURN NEXT;
                v_count := v_count + 1;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := v_current.name || delimiter_param;
                ELSE
                    v_next_seek := v_current.name;
                END IF;

                EXIT WHEN v_count >= max_keys;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text, sort_order text) OWNER TO supabase_storage_admin;

--
-- TOC entry 531 (class 1255 OID 17286)
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- TOC entry 422 (class 1255 OID 17351)
-- Name: protect_delete(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.protect_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if storage.allow_delete_query is set to 'true'
    IF COALESCE(current_setting('storage.allow_delete_query', true), 'false') != 'true' THEN
        RAISE EXCEPTION 'Direct deletion from storage tables is not allowed. Use the Storage API instead.'
            USING HINT = 'This prevents accidental data loss from orphaned objects.',
                  ERRCODE = '42501';
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.protect_delete() OWNER TO supabase_storage_admin;

--
-- TOC entry 426 (class 1255 OID 17220)
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;
    v_delimiter CONSTANT TEXT := '/';

    -- Configuration
    v_limit INT;
    v_prefix TEXT;
    v_prefix_lower TEXT;
    v_is_asc BOOLEAN;
    v_order_by TEXT;
    v_sort_order TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;
    v_skipped INT := 0;
BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_limit := LEAST(coalesce(limits, 100), 1500);
    v_prefix := coalesce(prefix, '') || coalesce(search, '');
    v_prefix_lower := lower(v_prefix);
    v_is_asc := lower(coalesce(sortorder, 'asc')) = 'asc';
    v_file_batch_size := LEAST(GREATEST(v_limit * 2, 100), 1000);

    -- Validate sort column
    CASE lower(coalesce(sortcolumn, 'name'))
        WHEN 'name' THEN v_order_by := 'name';
        WHEN 'updated_at' THEN v_order_by := 'updated_at';
        WHEN 'created_at' THEN v_order_by := 'created_at';
        WHEN 'last_accessed_at' THEN v_order_by := 'last_accessed_at';
        ELSE v_order_by := 'name';
    END CASE;

    v_sort_order := CASE WHEN v_is_asc THEN 'asc' ELSE 'desc' END;

    -- ========================================================================
    -- NON-NAME SORTING: Use path_tokens approach (unchanged)
    -- ========================================================================
    IF v_order_by != 'name' THEN
        RETURN QUERY EXECUTE format(
            $sql$
            WITH folders AS (
                SELECT path_tokens[$1] AS folder
                FROM storage.objects
                WHERE objects.name ILIKE $2 || '%%'
                  AND bucket_id = $3
                  AND array_length(objects.path_tokens, 1) <> $1
                GROUP BY folder
                ORDER BY folder %s
            )
            (SELECT folder AS "name",
                   NULL::uuid AS id,
                   NULL::timestamptz AS updated_at,
                   NULL::timestamptz AS created_at,
                   NULL::timestamptz AS last_accessed_at,
                   NULL::jsonb AS metadata FROM folders)
            UNION ALL
            (SELECT path_tokens[$1] AS "name",
                   id, updated_at, created_at, last_accessed_at, metadata
             FROM storage.objects
             WHERE objects.name ILIKE $2 || '%%'
               AND bucket_id = $3
               AND array_length(objects.path_tokens, 1) = $1
             ORDER BY %I %s)
            LIMIT $4 OFFSET $5
            $sql$, v_sort_order, v_order_by, v_sort_order
        ) USING levels, v_prefix, bucketname, v_limit, offsets;
        RETURN;
    END IF;

    -- ========================================================================
    -- NAME SORTING: Hybrid skip-scan with batch optimization
    -- ========================================================================

    -- Calculate upper bound for prefix filtering
    IF v_prefix_lower = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix_lower, 1) = v_delimiter THEN
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(v_delimiter) + 1);
    ELSE
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(right(v_prefix_lower, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'AND lower(o.name) COLLATE "C" < $3 ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'AND lower(o.name) COLLATE "C" >= $3 ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- Initialize seek position
    IF v_is_asc THEN
        v_next_seek := v_prefix_lower;
    ELSE
        -- DESC: find the last item in range first (static SQL)
        IF v_upper_bound IS NOT NULL THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower AND lower(o.name) COLLATE "C" < v_upper_bound
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSIF v_prefix_lower <> '' THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSE
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        END IF;

        IF v_peek_name IS NOT NULL THEN
            v_next_seek := lower(v_peek_name) || v_delimiter;
        ELSE
            RETURN;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= v_limit;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix_lower <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(lower(v_peek_name), v_prefix_lower, v_delimiter);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Handle offset, emit if needed, skip to next folder
            IF v_skipped < offsets THEN
                v_skipped := v_skipped + 1;
            ELSE
                name := split_part(rtrim(storage.get_common_prefix(v_peek_name, v_prefix, v_delimiter), v_delimiter), v_delimiter, levels);
                id := NULL;
                updated_at := NULL;
                created_at := NULL;
                last_accessed_at := NULL;
                metadata := NULL;
                RETURN NEXT;
                v_count := v_count + 1;
            END IF;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := lower(left(v_common_prefix, -1)) || chr(ascii(v_delimiter) + 1);
            ELSE
                v_next_seek := lower(v_common_prefix);
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix_lower is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(lower(v_current.name), v_prefix_lower, v_delimiter);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := lower(v_current.name);
                    EXIT;
                END IF;

                -- Handle offset skipping
                IF v_skipped < offsets THEN
                    v_skipped := v_skipped + 1;
                ELSE
                    -- Emit file
                    name := split_part(v_current.name, v_delimiter, levels);
                    id := v_current.id;
                    updated_at := v_current.updated_at;
                    created_at := v_current.created_at;
                    last_accessed_at := v_current.last_accessed_at;
                    metadata := v_current.metadata;
                    RETURN NEXT;
                    v_count := v_count + 1;
                END IF;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := lower(v_current.name) || v_delimiter;
                ELSE
                    v_next_seek := lower(v_current.name);
                END IF;

                EXIT WHEN v_count >= v_limit;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- TOC entry 501 (class 1255 OID 17349)
-- Name: search_by_timestamp(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_cursor_op text;
    v_query text;
    v_prefix text;
BEGIN
    v_prefix := coalesce(p_prefix, '');

    IF p_sort_order = 'asc' THEN
        v_cursor_op := '>';
    ELSE
        v_cursor_op := '<';
    END IF;

    v_query := format($sql$
        WITH raw_objects AS (
            SELECT
                o.name AS obj_name,
                o.id AS obj_id,
                o.updated_at AS obj_updated_at,
                o.created_at AS obj_created_at,
                o.last_accessed_at AS obj_last_accessed_at,
                o.metadata AS obj_metadata,
                storage.get_common_prefix(o.name, $1, '/') AS common_prefix
            FROM storage.objects o
            WHERE o.bucket_id = $2
              AND o.name COLLATE "C" LIKE $1 || '%%'
        ),
        -- Aggregate common prefixes (folders)
        -- Both created_at and updated_at use MIN(obj_created_at) to match the old prefixes table behavior
        aggregated_prefixes AS (
            SELECT
                rtrim(common_prefix, '/') AS name,
                NULL::uuid AS id,
                MIN(obj_created_at) AS updated_at,
                MIN(obj_created_at) AS created_at,
                NULL::timestamptz AS last_accessed_at,
                NULL::jsonb AS metadata,
                TRUE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NOT NULL
            GROUP BY common_prefix
        ),
        leaf_objects AS (
            SELECT
                obj_name AS name,
                obj_id AS id,
                obj_updated_at AS updated_at,
                obj_created_at AS created_at,
                obj_last_accessed_at AS last_accessed_at,
                obj_metadata AS metadata,
                FALSE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NULL
        ),
        combined AS (
            SELECT * FROM aggregated_prefixes
            UNION ALL
            SELECT * FROM leaf_objects
        ),
        filtered AS (
            SELECT *
            FROM combined
            WHERE (
                $5 = ''
                OR ROW(
                    date_trunc('milliseconds', %I),
                    name COLLATE "C"
                ) %s ROW(
                    COALESCE(NULLIF($6, '')::timestamptz, 'epoch'::timestamptz),
                    $5
                )
            )
        )
        SELECT
            split_part(name, '/', $3) AS key,
            name,
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
        FROM filtered
        ORDER BY
            COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz) %s,
            name COLLATE "C" %s
        LIMIT $4
    $sql$,
        p_sort_column,
        v_cursor_op,
        p_sort_column,
        p_sort_order,
        p_sort_order
    );

    RETURN QUERY EXECUTE v_query
    USING v_prefix, p_bucket_id, p_level, p_limit, p_start_after, p_sort_column_after;
END;
$_$;


ALTER FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) OWNER TO supabase_storage_admin;

--
-- TOC entry 467 (class 1255 OID 17348)
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_sort_col text;
    v_sort_ord text;
    v_limit int;
BEGIN
    -- Cap limit to maximum of 1500 records
    v_limit := LEAST(coalesce(limits, 100), 1500);

    -- Validate and normalize sort_order
    v_sort_ord := lower(coalesce(sort_order, 'asc'));
    IF v_sort_ord NOT IN ('asc', 'desc') THEN
        v_sort_ord := 'asc';
    END IF;

    -- Validate and normalize sort_column
    v_sort_col := lower(coalesce(sort_column, 'name'));
    IF v_sort_col NOT IN ('name', 'updated_at', 'created_at') THEN
        v_sort_col := 'name';
    END IF;

    -- Route to appropriate implementation
    IF v_sort_col = 'name' THEN
        -- Use list_objects_with_delimiter for name sorting (most efficient: O(k * log n))
        RETURN QUERY
        SELECT
            split_part(l.name, '/', levels) AS key,
            l.name AS name,
            l.id,
            l.updated_at,
            l.created_at,
            l.last_accessed_at,
            l.metadata
        FROM storage.list_objects_with_delimiter(
            bucket_name,
            coalesce(prefix, ''),
            '/',
            v_limit,
            start_after,
            '',
            v_sort_ord
        ) l;
    ELSE
        -- Use aggregation approach for timestamp sorting
        -- Not efficient for large datasets but supports correct pagination
        RETURN QUERY SELECT * FROM storage.search_by_timestamp(
            prefix, bucket_name, v_limit, levels, start_after,
            v_sort_ord, v_sort_col, sort_column_after
        );
    END IF;
END;
$$;


ALTER FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text, sort_order text, sort_column text, sort_column_after text) OWNER TO supabase_storage_admin;

--
-- TOC entry 507 (class 1255 OID 17221)
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 332 (class 1259 OID 16529)
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- TOC entry 5119 (class 0 OID 0)
-- Dependencies: 332
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- TOC entry 351 (class 1259 OID 17082)
-- Name: custom_oauth_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.custom_oauth_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_type text NOT NULL,
    identifier text NOT NULL,
    name text NOT NULL,
    client_id text NOT NULL,
    client_secret text NOT NULL,
    acceptable_client_ids text[] DEFAULT '{}'::text[] NOT NULL,
    scopes text[] DEFAULT '{}'::text[] NOT NULL,
    pkce_enabled boolean DEFAULT true NOT NULL,
    attribute_mapping jsonb DEFAULT '{}'::jsonb NOT NULL,
    authorization_params jsonb DEFAULT '{}'::jsonb NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    email_optional boolean DEFAULT false NOT NULL,
    issuer text,
    discovery_url text,
    skip_nonce_check boolean DEFAULT false NOT NULL,
    cached_discovery jsonb,
    discovery_cached_at timestamp with time zone,
    authorization_url text,
    token_url text,
    userinfo_url text,
    jwks_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT custom_oauth_providers_authorization_url_https CHECK (((authorization_url IS NULL) OR (authorization_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_authorization_url_length CHECK (((authorization_url IS NULL) OR (char_length(authorization_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_client_id_length CHECK (((char_length(client_id) >= 1) AND (char_length(client_id) <= 512))),
    CONSTRAINT custom_oauth_providers_discovery_url_length CHECK (((discovery_url IS NULL) OR (char_length(discovery_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_identifier_format CHECK ((identifier ~ '^[a-z0-9][a-z0-9:-]{0,48}[a-z0-9]$'::text)),
    CONSTRAINT custom_oauth_providers_issuer_length CHECK (((issuer IS NULL) OR ((char_length(issuer) >= 1) AND (char_length(issuer) <= 2048)))),
    CONSTRAINT custom_oauth_providers_jwks_uri_https CHECK (((jwks_uri IS NULL) OR (jwks_uri ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_jwks_uri_length CHECK (((jwks_uri IS NULL) OR (char_length(jwks_uri) <= 2048))),
    CONSTRAINT custom_oauth_providers_name_length CHECK (((char_length(name) >= 1) AND (char_length(name) <= 100))),
    CONSTRAINT custom_oauth_providers_oauth2_requires_endpoints CHECK (((provider_type <> 'oauth2'::text) OR ((authorization_url IS NOT NULL) AND (token_url IS NOT NULL) AND (userinfo_url IS NOT NULL)))),
    CONSTRAINT custom_oauth_providers_oidc_discovery_url_https CHECK (((provider_type <> 'oidc'::text) OR (discovery_url IS NULL) OR (discovery_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_issuer_https CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NULL) OR (issuer ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_requires_issuer CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NOT NULL))),
    CONSTRAINT custom_oauth_providers_provider_type_check CHECK ((provider_type = ANY (ARRAY['oauth2'::text, 'oidc'::text]))),
    CONSTRAINT custom_oauth_providers_token_url_https CHECK (((token_url IS NULL) OR (token_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_token_url_length CHECK (((token_url IS NULL) OR (char_length(token_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_userinfo_url_https CHECK (((userinfo_url IS NULL) OR (userinfo_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_userinfo_url_length CHECK (((userinfo_url IS NULL) OR (char_length(userinfo_url) <= 2048)))
);


ALTER TABLE auth.custom_oauth_providers OWNER TO supabase_auth_admin;

--
-- TOC entry 345 (class 1259 OID 16887)
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text,
    code_challenge_method auth.code_challenge_method,
    code_challenge text,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone,
    invite_token text,
    referrer text,
    oauth_client_state_id uuid,
    linking_target_id uuid,
    email_optional boolean DEFAULT false NOT NULL
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- TOC entry 5122 (class 0 OID 0)
-- Dependencies: 345
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- TOC entry 336 (class 1259 OID 16684)
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- TOC entry 5124 (class 0 OID 0)
-- Dependencies: 336
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- TOC entry 5125 (class 0 OID 0)
-- Dependencies: 336
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- TOC entry 331 (class 1259 OID 16522)
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- TOC entry 5127 (class 0 OID 0)
-- Dependencies: 331
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- TOC entry 340 (class 1259 OID 16774)
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- TOC entry 5129 (class 0 OID 0)
-- Dependencies: 340
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- TOC entry 339 (class 1259 OID 16762)
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- TOC entry 5131 (class 0 OID 0)
-- Dependencies: 339
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- TOC entry 338 (class 1259 OID 16749)
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- TOC entry 5133 (class 0 OID 0)
-- Dependencies: 338
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- TOC entry 5134 (class 0 OID 0)
-- Dependencies: 338
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- TOC entry 348 (class 1259 OID 16999)
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


ALTER TABLE auth.oauth_authorizations OWNER TO supabase_auth_admin;

--
-- TOC entry 350 (class 1259 OID 17072)
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE auth.oauth_client_states OWNER TO supabase_auth_admin;

--
-- TOC entry 5137 (class 0 OID 0)
-- Dependencies: 350
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- TOC entry 347 (class 1259 OID 16969)
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    token_endpoint_auth_method text NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048)),
    CONSTRAINT oauth_clients_token_endpoint_auth_method_check CHECK ((token_endpoint_auth_method = ANY (ARRAY['client_secret_basic'::text, 'client_secret_post'::text, 'none'::text])))
);


ALTER TABLE auth.oauth_clients OWNER TO supabase_auth_admin;

--
-- TOC entry 349 (class 1259 OID 17032)
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


ALTER TABLE auth.oauth_consents OWNER TO supabase_auth_admin;

--
-- TOC entry 346 (class 1259 OID 16937)
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- TOC entry 330 (class 1259 OID 16511)
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- TOC entry 5142 (class 0 OID 0)
-- Dependencies: 330
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- TOC entry 329 (class 1259 OID 16510)
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- TOC entry 5144 (class 0 OID 0)
-- Dependencies: 329
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- TOC entry 343 (class 1259 OID 16816)
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- TOC entry 5146 (class 0 OID 0)
-- Dependencies: 343
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- TOC entry 344 (class 1259 OID 16834)
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- TOC entry 5148 (class 0 OID 0)
-- Dependencies: 344
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- TOC entry 333 (class 1259 OID 16537)
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- TOC entry 5150 (class 0 OID 0)
-- Dependencies: 333
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- TOC entry 337 (class 1259 OID 16714)
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- TOC entry 5152 (class 0 OID 0)
-- Dependencies: 337
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- TOC entry 5153 (class 0 OID 0)
-- Dependencies: 337
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- TOC entry 5154 (class 0 OID 0)
-- Dependencies: 337
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- TOC entry 5155 (class 0 OID 0)
-- Dependencies: 337
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- TOC entry 342 (class 1259 OID 16801)
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- TOC entry 5157 (class 0 OID 0)
-- Dependencies: 342
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- TOC entry 341 (class 1259 OID 16792)
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- TOC entry 5159 (class 0 OID 0)
-- Dependencies: 341
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- TOC entry 5160 (class 0 OID 0)
-- Dependencies: 341
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- TOC entry 328 (class 1259 OID 16499)
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- TOC entry 5162 (class 0 OID 0)
-- Dependencies: 328
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- TOC entry 5163 (class 0 OID 0)
-- Dependencies: 328
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- TOC entry 353 (class 1259 OID 17147)
-- Name: webauthn_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.webauthn_challenges (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    challenge_type text NOT NULL,
    session_data jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    CONSTRAINT webauthn_challenges_challenge_type_check CHECK ((challenge_type = ANY (ARRAY['signup'::text, 'registration'::text, 'authentication'::text])))
);


ALTER TABLE auth.webauthn_challenges OWNER TO supabase_auth_admin;

--
-- TOC entry 352 (class 1259 OID 17124)
-- Name: webauthn_credentials; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.webauthn_credentials (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    credential_id bytea NOT NULL,
    public_key bytea NOT NULL,
    attestation_type text DEFAULT ''::text NOT NULL,
    aaguid uuid,
    sign_count bigint DEFAULT 0 NOT NULL,
    transports jsonb DEFAULT '[]'::jsonb NOT NULL,
    backup_eligible boolean DEFAULT false NOT NULL,
    backed_up boolean DEFAULT false NOT NULL,
    friendly_name text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone
);


ALTER TABLE auth.webauthn_credentials OWNER TO supabase_auth_admin;

--
-- TOC entry 405 (class 1259 OID 19865)
-- Name: active_team; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.active_team (
    profile_id uuid NOT NULL,
    team_id uuid,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.active_team OWNER TO postgres;

--
-- TOC entry 384 (class 1259 OID 18233)
-- Name: audit_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    admin_id uuid,
    action text NOT NULL,
    table_name text NOT NULL,
    record_id text,
    old_data jsonb,
    new_data jsonb,
    ip_address inet,
    user_agent text
);


ALTER TABLE public.audit_log OWNER TO postgres;

--
-- TOC entry 396 (class 1259 OID 18484)
-- Name: champion_masteries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.champion_masteries (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    riot_account_id uuid NOT NULL,
    champion_id integer NOT NULL,
    champion_name text,
    mastery_level integer DEFAULT 0 NOT NULL,
    mastery_points integer DEFAULT 0 NOT NULL,
    last_play_time timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.champion_masteries OWNER TO postgres;

--
-- TOC entry 382 (class 1259 OID 18189)
-- Name: disputes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.disputes (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    match_id uuid NOT NULL,
    reported_by uuid,
    reason text NOT NULL,
    evidence_url text,
    status public.dispute_status DEFAULT 'OPEN'::public.dispute_status,
    resolved_by uuid,
    resolution_notes text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.disputes OWNER TO postgres;

--
-- TOC entry 373 (class 1259 OID 17769)
-- Name: inscricoes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inscricoes (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    tournament_id uuid NOT NULL,
    team_id uuid NOT NULL,
    requested_by uuid,
    status public.inscricao_status DEFAULT 'PENDING'::public.inscricao_status NOT NULL,
    reviewed_by uuid,
    reviewed_at timestamp with time zone,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    checked_in_at timestamp with time zone,
    checked_in boolean DEFAULT false NOT NULL,
    checked_in_by uuid
);


ALTER TABLE public.inscricoes OWNER TO postgres;

--
-- TOC entry 5173 (class 0 OID 0)
-- Dependencies: 373
-- Name: COLUMN inscricoes.checked_in_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.inscricoes.checked_in_at IS 'timestamp do check-in';


--
-- TOC entry 5174 (class 0 OID 0)
-- Dependencies: 373
-- Name: COLUMN inscricoes.checked_in; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.inscricoes.checked_in IS 'true quando o time confirmou presença no torneio';


--
-- TOC entry 5175 (class 0 OID 0)
-- Dependencies: 373
-- Name: COLUMN inscricoes.checked_in_by; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.inscricoes.checked_in_by IS 'usuário que fez o check-in (capitão ou admin)';


--
-- TOC entry 376 (class 1259 OID 17895)
-- Name: match_games; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.match_games (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    match_id uuid NOT NULL,
    game_number integer NOT NULL,
    winner_id uuid,
    riot_game_id text,
    duration_sec integer,
    picks_bans jsonb,
    played_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT match_games_duration_sec_check CHECK ((duration_sec >= 0)),
    CONSTRAINT match_games_game_number_check CHECK ((game_number >= 1))
);


ALTER TABLE public.match_games OWNER TO postgres;

--
-- TOC entry 374 (class 1259 OID 17801)
-- Name: matches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.matches (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    tournament_id uuid NOT NULL,
    round integer DEFAULT 1 NOT NULL,
    match_order integer DEFAULT 1 NOT NULL,
    status public.match_status DEFAULT 'SCHEDULED'::public.match_status NOT NULL,
    team_a_id uuid,
    team_b_id uuid,
    winner_id uuid,
    score_a integer,
    score_b integer,
    riot_match_id text,
    scheduled_at timestamp with time zone,
    played_at timestamp with time zone,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    format text DEFAULT 'BO1'::text NOT NULL,
    stage_id uuid,
    match_number integer DEFAULT 1 NOT NULL,
    best_of integer DEFAULT 1 NOT NULL,
    finished_at timestamp with time zone,
    match_id_riot text,
    CONSTRAINT matches_format_check CHECK ((format = ANY (ARRAY['BO1'::text, 'BO3'::text, 'BO5'::text]))),
    CONSTRAINT matches_round_check CHECK ((round >= 1)),
    CONSTRAINT matches_score_a_check CHECK ((score_a >= 0)),
    CONSTRAINT matches_score_b_check CHECK ((score_b >= 0))
);


ALTER TABLE public.matches OWNER TO postgres;

--
-- TOC entry 378 (class 1259 OID 17977)
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    type text NOT NULL,
    title text NOT NULL,
    body text,
    read boolean DEFAULT false NOT NULL,
    metadata jsonb,
    expires_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    message text,
    link text
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- TOC entry 377 (class 1259 OID 17919)
-- Name: player_stats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.player_stats (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    game_id uuid NOT NULL,
    player_id uuid,
    team_id uuid,
    champion text,
    kills integer DEFAULT 0 NOT NULL,
    deaths integer DEFAULT 0 NOT NULL,
    assists integer DEFAULT 0 NOT NULL,
    cs integer DEFAULT 0 NOT NULL,
    vision_score integer DEFAULT 0 NOT NULL,
    damage_dealt integer DEFAULT 0 NOT NULL,
    is_mvp boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT player_stats_assists_check CHECK ((assists >= 0)),
    CONSTRAINT player_stats_cs_check CHECK ((cs >= 0)),
    CONSTRAINT player_stats_damage_dealt_check CHECK ((damage_dealt >= 0)),
    CONSTRAINT player_stats_deaths_check CHECK ((deaths >= 0)),
    CONSTRAINT player_stats_kills_check CHECK ((kills >= 0)),
    CONSTRAINT player_stats_vision_score_check CHECK ((vision_score >= 0))
);


ALTER TABLE public.player_stats OWNER TO postgres;

--
-- TOC entry 372 (class 1259 OID 17740)
-- Name: players; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.players (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    team_id uuid,
    summoner_name text NOT NULL,
    tag_line text DEFAULT 'BR1'::text NOT NULL,
    puuid text,
    role public.player_role,
    tier text DEFAULT 'UNRANKED'::text NOT NULL,
    rank text DEFAULT ''::text NOT NULL,
    lp integer DEFAULT 0 NOT NULL,
    wins integer DEFAULT 0 NOT NULL,
    losses integer DEFAULT 0 NOT NULL,
    profile_icon integer,
    summoner_level integer,
    last_synced timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT players_losses_check CHECK ((losses >= 0)),
    CONSTRAINT players_lp_check CHECK ((lp >= 0)),
    CONSTRAINT players_wins_check CHECK ((wins >= 0))
);


ALTER TABLE public.players OWNER TO postgres;

--
-- TOC entry 379 (class 1259 OID 18106)
-- Name: prize_distribution; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prize_distribution (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    tournament_id uuid NOT NULL,
    placement integer NOT NULL,
    description text NOT NULL,
    value text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT prize_distribution_placement_check CHECK ((placement >= 1))
);


ALTER TABLE public.prize_distribution OWNER TO postgres;

--
-- TOC entry 369 (class 1259 OID 17681)
-- Name: profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profiles (
    id uuid NOT NULL,
    email text NOT NULL,
    full_name text,
    avatar_url text,
    is_admin boolean DEFAULT false NOT NULL,
    is_banned boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    riot_game_name text,
    riot_tag_line text,
    role public.user_role DEFAULT 'player'::public.user_role NOT NULL
);


ALTER TABLE public.profiles OWNER TO postgres;

--
-- TOC entry 395 (class 1259 OID 18464)
-- Name: rank_snapshots; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rank_snapshots (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    riot_account_id uuid NOT NULL,
    queue_type text NOT NULL,
    tier text NOT NULL,
    rank text NOT NULL,
    lp integer DEFAULT 0 NOT NULL,
    wins integer DEFAULT 0 NOT NULL,
    losses integer DEFAULT 0 NOT NULL,
    hot_streak boolean DEFAULT false NOT NULL,
    snapshotted_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.rank_snapshots OWNER TO postgres;

--
-- TOC entry 394 (class 1259 OID 18442)
-- Name: riot_accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.riot_accounts (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    profile_id uuid NOT NULL,
    puuid text NOT NULL,
    game_name text NOT NULL,
    summoner_id text,
    summoner_level integer,
    profile_icon_id integer,
    is_primary boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    tag_line text NOT NULL
);


ALTER TABLE public.riot_accounts OWNER TO postgres;

--
-- TOC entry 380 (class 1259 OID 18121)
-- Name: seedings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.seedings (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    tournament_id uuid NOT NULL,
    team_id uuid NOT NULL,
    seed integer NOT NULL,
    method text DEFAULT 'MANUAL'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT seedings_method_check CHECK ((method = ANY (ARRAY['MANUAL'::text, 'RANKING'::text, 'RANDOM'::text]))),
    CONSTRAINT seedings_seed_check CHECK ((seed >= 1))
);


ALTER TABLE public.seedings OWNER TO postgres;

--
-- TOC entry 402 (class 1259 OID 18751)
-- Name: site_terms_acceptance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.site_terms_acceptance (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    profile_id uuid NOT NULL,
    terms_version text DEFAULT 'v1'::text NOT NULL,
    accepted_at timestamp with time zone DEFAULT now() NOT NULL,
    ip_address text
);


ALTER TABLE public.site_terms_acceptance OWNER TO postgres;

--
-- TOC entry 5187 (class 0 OID 0)
-- Dependencies: 402
-- Name: TABLE site_terms_acceptance; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.site_terms_acceptance IS 'Registro auditável de cada aceite dos termos da plataforma pelo organizador antes de criar torneio.';


--
-- TOC entry 381 (class 1259 OID 18157)
-- Name: team_invites; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.team_invites (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    team_id uuid NOT NULL,
    invited_by uuid,
    summoner_name text NOT NULL,
    tag_line text DEFAULT 'BR1'::text NOT NULL,
    role public.player_role,
    status public.invite_status DEFAULT 'PENDING'::public.invite_status,
    expires_at timestamp with time zone DEFAULT (now() + '48:00:00'::interval),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.team_invites OWNER TO postgres;

--
-- TOC entry 404 (class 1259 OID 19831)
-- Name: team_members; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.team_members (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    team_id uuid NOT NULL,
    profile_id uuid NOT NULL,
    riot_account_id uuid,
    team_role public.team_member_role DEFAULT 'member'::public.team_member_role NOT NULL,
    status public.team_member_status DEFAULT 'pending'::public.team_member_status NOT NULL,
    invited_by uuid,
    invited_at timestamp with time zone DEFAULT now() NOT NULL,
    responded_at timestamp with time zone
);


ALTER TABLE public.team_members OWNER TO postgres;

--
-- TOC entry 371 (class 1259 OID 17718)
-- Name: teams; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teams (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    tournament_id uuid,
    name text NOT NULL,
    tag text NOT NULL,
    logo_url text,
    owner_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    is_eliminated boolean DEFAULT false NOT NULL,
    slug text,
    description text,
    is_active boolean DEFAULT true NOT NULL,
    CONSTRAINT teams_tag_check CHECK (((length(tag) >= 1) AND (length(tag) <= 6)))
);


ALTER TABLE public.teams OWNER TO postgres;

--
-- TOC entry 406 (class 1259 OID 19923)
-- Name: tournament_match_results; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tournament_match_results (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    tournament_code text NOT NULL,
    game_id bigint,
    game_data jsonb NOT NULL,
    processed boolean DEFAULT false,
    received_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tournament_match_results OWNER TO postgres;

--
-- TOC entry 383 (class 1259 OID 18215)
-- Name: tournament_rules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tournament_rules (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    tournament_id uuid NOT NULL,
    section text NOT NULL,
    content text NOT NULL,
    rule_order integer DEFAULT 1,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tournament_rules OWNER TO postgres;

--
-- TOC entry 375 (class 1259 OID 17867)
-- Name: tournament_stages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tournament_stages (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    tournament_id uuid NOT NULL,
    name text NOT NULL,
    stage_order integer DEFAULT 1 NOT NULL,
    bracket_type public.bracket_type,
    best_of integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT tournament_stages_best_of_check CHECK ((best_of = ANY (ARRAY[1, 3, 5])))
);


ALTER TABLE public.tournament_stages OWNER TO postgres;

--
-- TOC entry 370 (class 1259 OID 17699)
-- Name: tournaments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tournaments (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    description text,
    status text DEFAULT 'DRAFT'::public.tournament_status NOT NULL,
    bracket_type public.bracket_type DEFAULT 'SINGLE_ELIMINATION'::public.bracket_type NOT NULL,
    max_teams integer DEFAULT 8 NOT NULL,
    prize_pool text,
    start_date timestamp with time zone,
    end_date timestamp with time zone,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    min_tier text,
    discord_webhook_url text,
    slug text NOT NULL,
    featured boolean DEFAULT false,
    banner_url text,
    registration_deadline timestamp with time zone,
    starts_at timestamp with time zone GENERATED ALWAYS AS (start_date) STORED,
    organizer_id uuid,
    rules text,
    min_members integer DEFAULT 1 NOT NULL,
    max_members integer DEFAULT 10 NOT NULL,
    ends_at timestamp with time zone,
    CONSTRAINT tournaments_max_teams_check CHECK ((max_teams >= 2))
);


ALTER TABLE public.tournaments OWNER TO postgres;

--
-- TOC entry 5195 (class 0 OID 0)
-- Dependencies: 370
-- Name: COLUMN tournaments.organizer_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.tournaments.organizer_id IS 'Perfil dono do torneio. Limite: 2 torneios não-cancelados por organizador.';


--
-- TOC entry 5196 (class 0 OID 0)
-- Dependencies: 370
-- Name: COLUMN tournaments.rules; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.tournaments.rules IS 'Regras do torneio definidas pelo organizador na etapa 1 do wizard de criação.';


--
-- TOC entry 388 (class 1259 OID 18331)
-- Name: v_player_leaderboard; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_player_leaderboard WITH (security_invoker='true') AS
 SELECT p.id AS player_id,
    p.summoner_name,
    p.tag_line,
    p.tier,
    p.rank,
    p.lp,
    p.profile_icon,
    count(DISTINCT t.tournament_id) AS tournaments_played,
    sum(ps.kills) AS total_kills,
    sum(ps.deaths) AS total_deaths,
    sum(ps.assists) AS total_assists,
    round((((sum(ps.kills))::numeric + (sum(ps.assists))::numeric) / NULLIF((sum(ps.deaths))::numeric, (0)::numeric)), 2) AS kda_ratio,
    count(ps.id) FILTER (WHERE (ps.is_mvp = true)) AS mvp_count,
    count(ps.id) AS total_games
   FROM ((public.players p
     LEFT JOIN public.player_stats ps ON ((ps.player_id = p.id)))
     LEFT JOIN public.teams t ON ((t.id = p.team_id)))
  GROUP BY p.id, p.summoner_name, p.tag_line, p.tier, p.rank, p.lp, p.profile_icon
  ORDER BY (round((((sum(ps.kills))::numeric + (sum(ps.assists))::numeric) / NULLIF((sum(ps.deaths))::numeric, (0)::numeric)), 2)) DESC NULLS LAST;


ALTER VIEW public.v_player_leaderboard OWNER TO postgres;

--
-- TOC entry 386 (class 1259 OID 18306)
-- Name: v_player_tournament_kda; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_player_tournament_kda WITH (security_invoker='true') AS
 SELECT ps.player_id,
    p.summoner_name,
    m.tournament_id,
    count(ps.id) AS games_played,
    round(avg(ps.kills), 2) AS avg_kills,
    round(avg(ps.deaths), 2) AS avg_deaths,
    round(avg(ps.assists), 2) AS avg_assists,
    round(
        CASE
            WHEN (avg(ps.deaths) = (0)::numeric) THEN (avg(ps.kills) + avg(ps.assists))
            ELSE ((avg(ps.kills) + avg(ps.assists)) / avg(ps.deaths))
        END, 2) AS kda_ratio,
    count(ps.id) FILTER (WHERE (ps.is_mvp = true)) AS mvp_count
   FROM (((public.player_stats ps
     JOIN public.players p ON ((p.id = ps.player_id)))
     JOIN public.match_games mg ON ((mg.id = ps.game_id)))
     JOIN public.matches m ON ((m.id = mg.match_id)))
  GROUP BY ps.player_id, p.summoner_name, m.tournament_id;


ALTER VIEW public.v_player_tournament_kda OWNER TO postgres;

--
-- TOC entry 387 (class 1259 OID 18311)
-- Name: v_stage_standings; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_stage_standings WITH (security_invoker='true') AS
 SELECT ts.tournament_id,
    ts.id AS stage_id,
    ts.name AS stage_name,
    t.id AS team_id,
    t.name AS team_name,
    t.tag,
    count(m.id) FILTER (WHERE (m.winner_id = t.id)) AS wins,
    count(m.id) FILTER (WHERE ((m.winner_id IS NOT NULL) AND (m.winner_id <> t.id) AND ((m.team_a_id = t.id) OR (m.team_b_id = t.id)))) AS losses,
    (count(m.id) FILTER (WHERE (m.winner_id = t.id)) * 3) AS points
   FROM ((public.tournament_stages ts
     JOIN public.matches m ON ((m.stage_id = ts.id)))
     JOIN public.teams t ON (((t.id = m.team_a_id) OR (t.id = m.team_b_id))))
  WHERE (m.status = 'FINISHED'::public.match_status)
  GROUP BY ts.tournament_id, ts.id, ts.name, t.id, t.name, t.tag;


ALTER VIEW public.v_stage_standings OWNER TO postgres;

--
-- TOC entry 368 (class 1259 OID 17529)
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- TOC entry 397 (class 1259 OID 18566)
-- Name: messages_2026_04_24; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_04_24 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_04_24 OWNER TO supabase_admin;

--
-- TOC entry 398 (class 1259 OID 18578)
-- Name: messages_2026_04_25; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_04_25 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_04_25 OWNER TO supabase_admin;

--
-- TOC entry 399 (class 1259 OID 18590)
-- Name: messages_2026_04_26; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_04_26 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_04_26 OWNER TO supabase_admin;

--
-- TOC entry 400 (class 1259 OID 18613)
-- Name: messages_2026_04_27; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_04_27 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_04_27 OWNER TO supabase_admin;

--
-- TOC entry 401 (class 1259 OID 18708)
-- Name: messages_2026_04_28; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_04_28 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_04_28 OWNER TO supabase_admin;

--
-- TOC entry 403 (class 1259 OID 18785)
-- Name: messages_2026_04_29; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_04_29 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_04_29 OWNER TO supabase_admin;

--
-- TOC entry 407 (class 1259 OID 20284)
-- Name: messages_2026_04_30; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_04_30 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_04_30 OWNER TO supabase_admin;

--
-- TOC entry 362 (class 1259 OID 17366)
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- TOC entry 365 (class 1259 OID 17389)
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    action_filter text DEFAULT '*'::text,
    CONSTRAINT subscription_action_filter_check CHECK ((action_filter = ANY (ARRAY['*'::text, 'INSERT'::text, 'UPDATE'::text, 'DELETE'::text])))
);


ALTER TABLE realtime.subscription OWNER TO supabase_admin;

--
-- TOC entry 364 (class 1259 OID 17388)
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 355 (class 1259 OID 17176)
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- TOC entry 5212 (class 0 OID 0)
-- Dependencies: 355
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- TOC entry 359 (class 1259 OID 17296)
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE storage.buckets_analytics OWNER TO supabase_storage_admin;

--
-- TOC entry 360 (class 1259 OID 17309)
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.buckets_vectors OWNER TO supabase_storage_admin;

--
-- TOC entry 354 (class 1259 OID 17168)
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- TOC entry 356 (class 1259 OID 17186)
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- TOC entry 5216 (class 0 OID 0)
-- Dependencies: 356
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- TOC entry 357 (class 1259 OID 17235)
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb,
    metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- TOC entry 358 (class 1259 OID 17249)
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- TOC entry 361 (class 1259 OID 17319)
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.vector_indexes OWNER TO supabase_storage_admin;

--
-- TOC entry 385 (class 1259 OID 18257)
-- Name: schema_migrations; Type: TABLE; Schema: supabase_migrations; Owner: postgres
--

CREATE TABLE supabase_migrations.schema_migrations (
    version text NOT NULL,
    statements text[],
    name text,
    created_by text,
    idempotency_key text,
    rollback text[]
);


ALTER TABLE supabase_migrations.schema_migrations OWNER TO postgres;

--
-- TOC entry 3954 (class 0 OID 0)
-- Name: messages_2026_04_24; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_04_24 FOR VALUES FROM ('2026-04-24 00:00:00') TO ('2026-04-25 00:00:00');


--
-- TOC entry 3955 (class 0 OID 0)
-- Name: messages_2026_04_25; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_04_25 FOR VALUES FROM ('2026-04-25 00:00:00') TO ('2026-04-26 00:00:00');


--
-- TOC entry 3956 (class 0 OID 0)
-- Name: messages_2026_04_26; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_04_26 FOR VALUES FROM ('2026-04-26 00:00:00') TO ('2026-04-27 00:00:00');


--
-- TOC entry 3957 (class 0 OID 0)
-- Name: messages_2026_04_27; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_04_27 FOR VALUES FROM ('2026-04-27 00:00:00') TO ('2026-04-28 00:00:00');


--
-- TOC entry 3958 (class 0 OID 0)
-- Name: messages_2026_04_28; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_04_28 FOR VALUES FROM ('2026-04-28 00:00:00') TO ('2026-04-29 00:00:00');


--
-- TOC entry 3959 (class 0 OID 0)
-- Name: messages_2026_04_29; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_04_29 FOR VALUES FROM ('2026-04-29 00:00:00') TO ('2026-04-30 00:00:00');


--
-- TOC entry 3960 (class 0 OID 0)
-- Name: messages_2026_04_30; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_04_30 FOR VALUES FROM ('2026-04-30 00:00:00') TO ('2026-05-01 00:00:00');


--
-- TOC entry 3970 (class 2604 OID 16514)
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- TOC entry 4306 (class 2606 OID 16787)
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- TOC entry 4275 (class 2606 OID 16535)
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- TOC entry 4361 (class 2606 OID 17119)
-- Name: custom_oauth_providers custom_oauth_providers_identifier_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_identifier_key UNIQUE (identifier);


--
-- TOC entry 4363 (class 2606 OID 17117)
-- Name: custom_oauth_providers custom_oauth_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 4329 (class 2606 OID 16893)
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- TOC entry 4284 (class 2606 OID 16911)
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- TOC entry 4286 (class 2606 OID 16921)
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- TOC entry 4273 (class 2606 OID 16528)
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- TOC entry 4308 (class 2606 OID 16780)
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- TOC entry 4304 (class 2606 OID 16768)
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- TOC entry 4296 (class 2606 OID 16961)
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- TOC entry 4298 (class 2606 OID 16755)
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- TOC entry 4342 (class 2606 OID 17020)
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- TOC entry 4344 (class 2606 OID 17018)
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- TOC entry 4346 (class 2606 OID 17016)
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- TOC entry 4356 (class 2606 OID 17078)
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- TOC entry 4339 (class 2606 OID 16980)
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- TOC entry 4350 (class 2606 OID 17042)
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- TOC entry 4352 (class 2606 OID 17044)
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- TOC entry 4333 (class 2606 OID 16946)
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4267 (class 2606 OID 16518)
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4270 (class 2606 OID 16697)
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- TOC entry 4318 (class 2606 OID 16827)
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- TOC entry 4320 (class 2606 OID 16825)
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 4325 (class 2606 OID 16841)
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- TOC entry 4278 (class 2606 OID 16541)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4291 (class 2606 OID 16718)
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 4315 (class 2606 OID 16808)
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- TOC entry 4310 (class 2606 OID 16799)
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 4260 (class 2606 OID 16881)
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- TOC entry 4262 (class 2606 OID 16505)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4371 (class 2606 OID 17156)
-- Name: webauthn_challenges webauthn_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_pkey PRIMARY KEY (id);


--
-- TOC entry 4367 (class 2606 OID 17139)
-- Name: webauthn_credentials webauthn_credentials_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_pkey PRIMARY KEY (id);


--
-- TOC entry 4549 (class 2606 OID 19870)
-- Name: active_team active_team_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_team
    ADD CONSTRAINT active_team_pkey PRIMARY KEY (profile_id);


--
-- TOC entry 4496 (class 2606 OID 18241)
-- Name: audit_log audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_pkey PRIMARY KEY (id);


--
-- TOC entry 4514 (class 2606 OID 18495)
-- Name: champion_masteries champion_masteries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.champion_masteries
    ADD CONSTRAINT champion_masteries_pkey PRIMARY KEY (id);


--
-- TOC entry 4516 (class 2606 OID 18497)
-- Name: champion_masteries champion_masteries_unique_account_champion; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.champion_masteries
    ADD CONSTRAINT champion_masteries_unique_account_champion UNIQUE (riot_account_id, champion_id);


--
-- TOC entry 4492 (class 2606 OID 18199)
-- Name: disputes disputes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disputes
    ADD CONSTRAINT disputes_pkey PRIMARY KEY (id);


--
-- TOC entry 4441 (class 2606 OID 17778)
-- Name: inscricoes inscricoes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inscricoes
    ADD CONSTRAINT inscricoes_pkey PRIMARY KEY (id);


--
-- TOC entry 4443 (class 2606 OID 17780)
-- Name: inscricoes inscricoes_tournament_id_team_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inscricoes
    ADD CONSTRAINT inscricoes_tournament_id_team_id_key UNIQUE (tournament_id, team_id);


--
-- TOC entry 4457 (class 2606 OID 17907)
-- Name: match_games match_games_match_id_game_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_games
    ADD CONSTRAINT match_games_match_id_game_number_key UNIQUE (match_id, game_number);


--
-- TOC entry 4459 (class 2606 OID 17905)
-- Name: match_games match_games_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_games
    ADD CONSTRAINT match_games_pkey PRIMARY KEY (id);


--
-- TOC entry 4451 (class 2606 OID 17816)
-- Name: matches matches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_pkey PRIMARY KEY (id);


--
-- TOC entry 4474 (class 2606 OID 17986)
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 4466 (class 2606 OID 17940)
-- Name: player_stats player_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.player_stats
    ADD CONSTRAINT player_stats_pkey PRIMARY KEY (id);


--
-- TOC entry 4431 (class 2606 OID 17758)
-- Name: players players_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_pkey PRIMARY KEY (id);


--
-- TOC entry 4433 (class 2606 OID 17760)
-- Name: players players_puuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_puuid_key UNIQUE (puuid);


--
-- TOC entry 4477 (class 2606 OID 18115)
-- Name: prize_distribution prize_distribution_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prize_distribution
    ADD CONSTRAINT prize_distribution_pkey PRIMARY KEY (id);


--
-- TOC entry 4409 (class 2606 OID 17691)
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- TOC entry 4512 (class 2606 OID 18476)
-- Name: rank_snapshots rank_snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rank_snapshots
    ADD CONSTRAINT rank_snapshots_pkey PRIMARY KEY (id);


--
-- TOC entry 4508 (class 2606 OID 18452)
-- Name: riot_accounts riot_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.riot_accounts
    ADD CONSTRAINT riot_accounts_pkey PRIMARY KEY (id);


--
-- TOC entry 4481 (class 2606 OID 18132)
-- Name: seedings seedings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seedings
    ADD CONSTRAINT seedings_pkey PRIMARY KEY (id);


--
-- TOC entry 4483 (class 2606 OID 18136)
-- Name: seedings seedings_tournament_id_seed_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seedings
    ADD CONSTRAINT seedings_tournament_id_seed_key UNIQUE (tournament_id, seed);


--
-- TOC entry 4485 (class 2606 OID 18134)
-- Name: seedings seedings_tournament_id_team_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seedings
    ADD CONSTRAINT seedings_tournament_id_team_id_key UNIQUE (tournament_id, team_id);


--
-- TOC entry 4535 (class 2606 OID 18760)
-- Name: site_terms_acceptance site_terms_acceptance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.site_terms_acceptance
    ADD CONSTRAINT site_terms_acceptance_pkey PRIMARY KEY (id);


--
-- TOC entry 4490 (class 2606 OID 18168)
-- Name: team_invites team_invites_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_invites
    ADD CONSTRAINT team_invites_pkey PRIMARY KEY (id);


--
-- TOC entry 4545 (class 2606 OID 19839)
-- Name: team_members team_members_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT team_members_pkey PRIMARY KEY (id);


--
-- TOC entry 4547 (class 2606 OID 19841)
-- Name: team_members team_members_team_id_profile_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT team_members_team_id_profile_id_key UNIQUE (team_id, profile_id);


--
-- TOC entry 4418 (class 2606 OID 17727)
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- TOC entry 4420 (class 2606 OID 20281)
-- Name: teams teams_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_slug_key UNIQUE (slug);


--
-- TOC entry 4423 (class 2606 OID 17729)
-- Name: teams teams_tournament_id_tag_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_tournament_id_tag_key UNIQUE (tournament_id, tag);


--
-- TOC entry 4551 (class 2606 OID 19932)
-- Name: tournament_match_results tournament_match_results_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tournament_match_results
    ADD CONSTRAINT tournament_match_results_pkey PRIMARY KEY (id);


--
-- TOC entry 4553 (class 2606 OID 19934)
-- Name: tournament_match_results tournament_match_results_tournament_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tournament_match_results
    ADD CONSTRAINT tournament_match_results_tournament_code_key UNIQUE (tournament_code);


--
-- TOC entry 4494 (class 2606 OID 18224)
-- Name: tournament_rules tournament_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tournament_rules
    ADD CONSTRAINT tournament_rules_pkey PRIMARY KEY (id);


--
-- TOC entry 4454 (class 2606 OID 17879)
-- Name: tournament_stages tournament_stages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tournament_stages
    ADD CONSTRAINT tournament_stages_pkey PRIMARY KEY (id);


--
-- TOC entry 4413 (class 2606 OID 17712)
-- Name: tournaments tournaments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tournaments
    ADD CONSTRAINT tournaments_pkey PRIMARY KEY (id);


--
-- TOC entry 4416 (class 2606 OID 18605)
-- Name: tournaments tournaments_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tournaments
    ADD CONSTRAINT tournaments_slug_key UNIQUE (slug);


--
-- TOC entry 4537 (class 2606 OID 18762)
-- Name: site_terms_acceptance uq_profile_terms_version; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.site_terms_acceptance
    ADD CONSTRAINT uq_profile_terms_version UNIQUE (profile_id, terms_version);


--
-- TOC entry 4407 (class 2606 OID 17543)
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4520 (class 2606 OID 18574)
-- Name: messages_2026_04_24 messages_2026_04_24_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_04_24
    ADD CONSTRAINT messages_2026_04_24_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4523 (class 2606 OID 18586)
-- Name: messages_2026_04_25 messages_2026_04_25_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_04_25
    ADD CONSTRAINT messages_2026_04_25_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4526 (class 2606 OID 18598)
-- Name: messages_2026_04_26 messages_2026_04_26_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_04_26
    ADD CONSTRAINT messages_2026_04_26_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4529 (class 2606 OID 18621)
-- Name: messages_2026_04_27 messages_2026_04_27_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_04_27
    ADD CONSTRAINT messages_2026_04_27_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4532 (class 2606 OID 18716)
-- Name: messages_2026_04_28 messages_2026_04_28_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_04_28
    ADD CONSTRAINT messages_2026_04_28_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4540 (class 2606 OID 18793)
-- Name: messages_2026_04_29 messages_2026_04_29_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_04_29
    ADD CONSTRAINT messages_2026_04_29_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4556 (class 2606 OID 20292)
-- Name: messages_2026_04_30 messages_2026_04_30_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_04_30
    ADD CONSTRAINT messages_2026_04_30_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4403 (class 2606 OID 17397)
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- TOC entry 4400 (class 2606 OID 17370)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4392 (class 2606 OID 17342)
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- TOC entry 4379 (class 2606 OID 17184)
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- TOC entry 4395 (class 2606 OID 17318)
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- TOC entry 4374 (class 2606 OID 17175)
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- TOC entry 4376 (class 2606 OID 17173)
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 4385 (class 2606 OID 17196)
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- TOC entry 4390 (class 2606 OID 17258)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- TOC entry 4388 (class 2606 OID 17243)
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- TOC entry 4398 (class 2606 OID 17328)
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- TOC entry 4501 (class 2606 OID 18265)
-- Name: schema_migrations schema_migrations_idempotency_key_key; Type: CONSTRAINT; Schema: supabase_migrations; Owner: postgres
--

ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_idempotency_key_key UNIQUE (idempotency_key);


--
-- TOC entry 4503 (class 2606 OID 18263)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: postgres
--

ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4276 (class 1259 OID 16536)
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- TOC entry 4246 (class 1259 OID 16707)
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4357 (class 1259 OID 17123)
-- Name: custom_oauth_providers_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_created_at_idx ON auth.custom_oauth_providers USING btree (created_at);


--
-- TOC entry 4358 (class 1259 OID 17122)
-- Name: custom_oauth_providers_enabled_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_enabled_idx ON auth.custom_oauth_providers USING btree (enabled);


--
-- TOC entry 4359 (class 1259 OID 17120)
-- Name: custom_oauth_providers_identifier_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_identifier_idx ON auth.custom_oauth_providers USING btree (identifier);


--
-- TOC entry 4364 (class 1259 OID 17121)
-- Name: custom_oauth_providers_provider_type_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_provider_type_idx ON auth.custom_oauth_providers USING btree (provider_type);


--
-- TOC entry 4247 (class 1259 OID 16709)
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4248 (class 1259 OID 16710)
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4294 (class 1259 OID 16789)
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- TOC entry 4327 (class 1259 OID 16897)
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- TOC entry 4282 (class 1259 OID 16877)
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- TOC entry 5223 (class 0 OID 0)
-- Dependencies: 4282
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- TOC entry 4287 (class 1259 OID 16704)
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- TOC entry 4330 (class 1259 OID 16894)
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- TOC entry 4354 (class 1259 OID 17079)
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- TOC entry 4331 (class 1259 OID 16895)
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- TOC entry 4249 (class 1259 OID 17165)
-- Name: idx_users_created_at_desc; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_users_created_at_desc ON auth.users USING btree (created_at DESC);


--
-- TOC entry 4250 (class 1259 OID 17164)
-- Name: idx_users_email; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_users_email ON auth.users USING btree (email);


--
-- TOC entry 4251 (class 1259 OID 17166)
-- Name: idx_users_last_sign_in_at_desc; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_users_last_sign_in_at_desc ON auth.users USING btree (last_sign_in_at DESC);


--
-- TOC entry 4252 (class 1259 OID 17167)
-- Name: idx_users_name; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_users_name ON auth.users USING btree (((raw_user_meta_data ->> 'name'::text))) WHERE ((raw_user_meta_data ->> 'name'::text) IS NOT NULL);


--
-- TOC entry 4302 (class 1259 OID 16900)
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- TOC entry 4299 (class 1259 OID 16761)
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- TOC entry 4300 (class 1259 OID 16906)
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- TOC entry 4340 (class 1259 OID 17031)
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- TOC entry 4337 (class 1259 OID 16984)
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- TOC entry 4347 (class 1259 OID 17057)
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- TOC entry 4348 (class 1259 OID 17055)
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- TOC entry 4353 (class 1259 OID 17056)
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- TOC entry 4334 (class 1259 OID 16953)
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- TOC entry 4335 (class 1259 OID 16952)
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- TOC entry 4336 (class 1259 OID 16954)
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- TOC entry 4253 (class 1259 OID 16711)
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4254 (class 1259 OID 16708)
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4263 (class 1259 OID 16519)
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- TOC entry 4264 (class 1259 OID 16520)
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- TOC entry 4265 (class 1259 OID 16703)
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- TOC entry 4268 (class 1259 OID 16791)
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- TOC entry 4271 (class 1259 OID 16896)
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- TOC entry 4321 (class 1259 OID 16833)
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- TOC entry 4322 (class 1259 OID 16898)
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- TOC entry 4323 (class 1259 OID 16848)
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- TOC entry 4326 (class 1259 OID 16847)
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- TOC entry 4288 (class 1259 OID 16899)
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- TOC entry 4289 (class 1259 OID 17069)
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- TOC entry 4292 (class 1259 OID 16790)
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- TOC entry 4313 (class 1259 OID 16815)
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- TOC entry 4316 (class 1259 OID 16814)
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- TOC entry 4311 (class 1259 OID 16800)
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- TOC entry 4312 (class 1259 OID 16962)
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- TOC entry 4301 (class 1259 OID 16959)
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- TOC entry 4293 (class 1259 OID 16788)
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- TOC entry 4255 (class 1259 OID 16868)
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- TOC entry 5224 (class 0 OID 0)
-- Dependencies: 4255
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- TOC entry 4256 (class 1259 OID 16705)
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- TOC entry 4257 (class 1259 OID 16509)
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- TOC entry 4258 (class 1259 OID 16923)
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- TOC entry 4369 (class 1259 OID 17163)
-- Name: webauthn_challenges_expires_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_expires_at_idx ON auth.webauthn_challenges USING btree (expires_at);


--
-- TOC entry 4372 (class 1259 OID 17162)
-- Name: webauthn_challenges_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_user_id_idx ON auth.webauthn_challenges USING btree (user_id);


--
-- TOC entry 4365 (class 1259 OID 17145)
-- Name: webauthn_credentials_credential_id_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX webauthn_credentials_credential_id_key ON auth.webauthn_credentials USING btree (credential_id);


--
-- TOC entry 4368 (class 1259 OID 17146)
-- Name: webauthn_credentials_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_credentials_user_id_idx ON auth.webauthn_credentials USING btree (user_id);


--
-- TOC entry 4497 (class 1259 OID 18250)
-- Name: idx_audit_log_admin_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_log_admin_id ON public.audit_log USING btree (admin_id);


--
-- TOC entry 4498 (class 1259 OID 18249)
-- Name: idx_audit_log_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_log_created_at ON public.audit_log USING btree (created_at DESC);


--
-- TOC entry 4499 (class 1259 OID 18251)
-- Name: idx_audit_log_table_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_log_table_name ON public.audit_log USING btree (table_name);


--
-- TOC entry 4517 (class 1259 OID 18503)
-- Name: idx_champion_masteries_account; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_champion_masteries_account ON public.champion_masteries USING btree (riot_account_id);


--
-- TOC entry 4434 (class 1259 OID 18540)
-- Name: idx_inscricoes_requested_by; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inscricoes_requested_by ON public.inscricoes USING btree (requested_by);


--
-- TOC entry 4435 (class 1259 OID 18541)
-- Name: idx_inscricoes_requested_by_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inscricoes_requested_by_status ON public.inscricoes USING btree (requested_by, status);


--
-- TOC entry 4436 (class 1259 OID 18538)
-- Name: idx_inscricoes_team_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inscricoes_team_id ON public.inscricoes USING btree (team_id);


--
-- TOC entry 4437 (class 1259 OID 19803)
-- Name: idx_inscricoes_tournament_checkin; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inscricoes_tournament_checkin ON public.inscricoes USING btree (tournament_id, checked_in);


--
-- TOC entry 4438 (class 1259 OID 18539)
-- Name: idx_inscricoes_tournament_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inscricoes_tournament_id ON public.inscricoes USING btree (tournament_id);


--
-- TOC entry 4439 (class 1259 OID 18341)
-- Name: idx_inscricoes_tournament_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inscricoes_tournament_status ON public.inscricoes USING btree (tournament_id, status);


--
-- TOC entry 4455 (class 1259 OID 17918)
-- Name: idx_match_games_match; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_match_games_match ON public.match_games USING btree (match_id);


--
-- TOC entry 4444 (class 1259 OID 17838)
-- Name: idx_matches_round; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_matches_round ON public.matches USING btree (tournament_id, round);


--
-- TOC entry 4445 (class 1259 OID 18339)
-- Name: idx_matches_stage_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_matches_stage_id ON public.matches USING btree (stage_id) WHERE (stage_id IS NOT NULL);


--
-- TOC entry 4446 (class 1259 OID 18340)
-- Name: idx_matches_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_matches_status ON public.matches USING btree (status);


--
-- TOC entry 4447 (class 1259 OID 17837)
-- Name: idx_matches_tournament; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_matches_tournament ON public.matches USING btree (tournament_id);


--
-- TOC entry 4448 (class 1259 OID 18338)
-- Name: idx_matches_tournament_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_matches_tournament_id ON public.matches USING btree (tournament_id);


--
-- TOC entry 4449 (class 1259 OID 19905)
-- Name: idx_matches_tournament_round; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_matches_tournament_round ON public.matches USING btree (tournament_id, round, match_number);


--
-- TOC entry 4467 (class 1259 OID 17994)
-- Name: idx_notifications_expires; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_expires ON public.notifications USING btree (expires_at);


--
-- TOC entry 4468 (class 1259 OID 18525)
-- Name: idx_notifications_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_type ON public.notifications USING btree (type);


--
-- TOC entry 4469 (class 1259 OID 17993)
-- Name: idx_notifications_unread; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_unread ON public.notifications USING btree (user_id) WHERE (read = false);


--
-- TOC entry 4470 (class 1259 OID 17992)
-- Name: idx_notifications_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_user ON public.notifications USING btree (user_id);


--
-- TOC entry 4471 (class 1259 OID 18524)
-- Name: idx_notifications_user_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_user_created_at ON public.notifications USING btree (user_id, created_at DESC);


--
-- TOC entry 4472 (class 1259 OID 18342)
-- Name: idx_notifications_user_unread; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_user_unread ON public.notifications USING btree (user_id, read) WHERE (read = false);


--
-- TOC entry 4460 (class 1259 OID 17956)
-- Name: idx_player_stats_game; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_player_stats_game ON public.player_stats USING btree (game_id);


--
-- TOC entry 4461 (class 1259 OID 18337)
-- Name: idx_player_stats_game_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_player_stats_game_id ON public.player_stats USING btree (game_id);


--
-- TOC entry 4462 (class 1259 OID 17957)
-- Name: idx_player_stats_player; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_player_stats_player ON public.player_stats USING btree (player_id);


--
-- TOC entry 4463 (class 1259 OID 18336)
-- Name: idx_player_stats_player_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_player_stats_player_id ON public.player_stats USING btree (player_id);


--
-- TOC entry 4464 (class 1259 OID 17958)
-- Name: idx_player_stats_team; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_player_stats_team ON public.player_stats USING btree (team_id);


--
-- TOC entry 4424 (class 1259 OID 18348)
-- Name: idx_players_last_synced; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_players_last_synced ON public.players USING btree (last_synced) WHERE (last_synced IS NOT NULL);


--
-- TOC entry 4425 (class 1259 OID 17768)
-- Name: idx_players_name_trgm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_players_name_trgm ON public.players USING gin (summoner_name public.gin_trgm_ops);


--
-- TOC entry 4426 (class 1259 OID 17767)
-- Name: idx_players_puuid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_players_puuid ON public.players USING btree (puuid);


--
-- TOC entry 4427 (class 1259 OID 18537)
-- Name: idx_players_summoner_name_trgm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_players_summoner_name_trgm ON public.players USING gin (summoner_name public.gin_trgm_ops);


--
-- TOC entry 4428 (class 1259 OID 17766)
-- Name: idx_players_team_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_players_team_id ON public.players USING btree (team_id);


--
-- TOC entry 4429 (class 1259 OID 18536)
-- Name: idx_players_team_role; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_players_team_role ON public.players USING btree (team_id, role);


--
-- TOC entry 4509 (class 1259 OID 18483)
-- Name: idx_rank_snapshots_account_queue; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rank_snapshots_account_queue ON public.rank_snapshots USING btree (riot_account_id, queue_type);


--
-- TOC entry 4510 (class 1259 OID 18482)
-- Name: idx_rank_snapshots_account_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rank_snapshots_account_time ON public.rank_snapshots USING btree (riot_account_id, snapshotted_at DESC);


--
-- TOC entry 4504 (class 1259 OID 18459)
-- Name: idx_riot_accounts_primary_per_profile; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_riot_accounts_primary_per_profile ON public.riot_accounts USING btree (profile_id) WHERE (is_primary = true);


--
-- TOC entry 4505 (class 1259 OID 18460)
-- Name: idx_riot_accounts_profile_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_riot_accounts_profile_id ON public.riot_accounts USING btree (profile_id);


--
-- TOC entry 4506 (class 1259 OID 18458)
-- Name: idx_riot_accounts_puuid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_riot_accounts_puuid ON public.riot_accounts USING btree (puuid);


--
-- TOC entry 4478 (class 1259 OID 18345)
-- Name: idx_seedings_seed; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_seedings_seed ON public.seedings USING btree (tournament_id, seed);


--
-- TOC entry 4479 (class 1259 OID 18344)
-- Name: idx_seedings_tournament; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_seedings_tournament ON public.seedings USING btree (tournament_id);


--
-- TOC entry 4533 (class 1259 OID 18768)
-- Name: idx_site_terms_acceptance_profile; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_site_terms_acceptance_profile ON public.site_terms_acceptance USING btree (profile_id);


--
-- TOC entry 4452 (class 1259 OID 17885)
-- Name: idx_stages_tournament; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_stages_tournament ON public.tournament_stages USING btree (tournament_id);


--
-- TOC entry 4486 (class 1259 OID 19915)
-- Name: idx_team_invites_expires; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_team_invites_expires ON public.team_invites USING btree (expires_at) WHERE (status = 'PENDING'::public.invite_status);


--
-- TOC entry 4487 (class 1259 OID 19914)
-- Name: idx_team_invites_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_team_invites_status ON public.team_invites USING btree (status);


--
-- TOC entry 4488 (class 1259 OID 19913)
-- Name: idx_team_invites_team; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_team_invites_team ON public.team_invites USING btree (team_id);


--
-- TOC entry 4541 (class 1259 OID 19863)
-- Name: idx_team_members_profile; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_team_members_profile ON public.team_members USING btree (profile_id);


--
-- TOC entry 4542 (class 1259 OID 19864)
-- Name: idx_team_members_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_team_members_status ON public.team_members USING btree (status);


--
-- TOC entry 4543 (class 1259 OID 19862)
-- Name: idx_team_members_team; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_team_members_team ON public.team_members USING btree (team_id);


--
-- TOC entry 4410 (class 1259 OID 18779)
-- Name: idx_tournaments_organizer; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tournaments_organizer ON public.tournaments USING btree (organizer_id);


--
-- TOC entry 4411 (class 1259 OID 18606)
-- Name: idx_tournaments_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tournaments_slug ON public.tournaments USING btree (slug);


--
-- TOC entry 4475 (class 1259 OID 18433)
-- Name: notifications_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX notifications_user_id_idx ON public.notifications USING btree (user_id, created_at DESC);


--
-- TOC entry 4421 (class 1259 OID 20283)
-- Name: teams_slug_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX teams_slug_unique ON public.teams USING btree (slug) WHERE (slug IS NOT NULL);


--
-- TOC entry 4414 (class 1259 OID 18320)
-- Name: tournaments_slug_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tournaments_slug_idx ON public.tournaments USING btree (slug);


--
-- TOC entry 4401 (class 1259 OID 17544)
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- TOC entry 4405 (class 1259 OID 17545)
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4518 (class 1259 OID 18575)
-- Name: messages_2026_04_24_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_04_24_inserted_at_topic_idx ON realtime.messages_2026_04_24 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4521 (class 1259 OID 18587)
-- Name: messages_2026_04_25_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_04_25_inserted_at_topic_idx ON realtime.messages_2026_04_25 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4524 (class 1259 OID 18599)
-- Name: messages_2026_04_26_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_04_26_inserted_at_topic_idx ON realtime.messages_2026_04_26 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4527 (class 1259 OID 18622)
-- Name: messages_2026_04_27_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_04_27_inserted_at_topic_idx ON realtime.messages_2026_04_27 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4530 (class 1259 OID 18717)
-- Name: messages_2026_04_28_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_04_28_inserted_at_topic_idx ON realtime.messages_2026_04_28 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4538 (class 1259 OID 18794)
-- Name: messages_2026_04_29_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_04_29_inserted_at_topic_idx ON realtime.messages_2026_04_29 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4554 (class 1259 OID 20293)
-- Name: messages_2026_04_30_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_04_30_inserted_at_topic_idx ON realtime.messages_2026_04_30 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4404 (class 1259 OID 17548)
-- Name: subscription_subscription_id_entity_filters_action_filter_key; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_key ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter);


--
-- TOC entry 4377 (class 1259 OID 17185)
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- TOC entry 4380 (class 1259 OID 17202)
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- TOC entry 4393 (class 1259 OID 17343)
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- TOC entry 4386 (class 1259 OID 17269)
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- TOC entry 4381 (class 1259 OID 17234)
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- TOC entry 4382 (class 1259 OID 17350)
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- TOC entry 4383 (class 1259 OID 17203)
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- TOC entry 4396 (class 1259 OID 17334)
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- TOC entry 4557 (class 0 OID 0)
-- Name: messages_2026_04_24_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_04_24_inserted_at_topic_idx;


--
-- TOC entry 4558 (class 0 OID 0)
-- Name: messages_2026_04_24_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_04_24_pkey;


--
-- TOC entry 4559 (class 0 OID 0)
-- Name: messages_2026_04_25_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_04_25_inserted_at_topic_idx;


--
-- TOC entry 4560 (class 0 OID 0)
-- Name: messages_2026_04_25_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_04_25_pkey;


--
-- TOC entry 4561 (class 0 OID 0)
-- Name: messages_2026_04_26_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_04_26_inserted_at_topic_idx;


--
-- TOC entry 4562 (class 0 OID 0)
-- Name: messages_2026_04_26_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_04_26_pkey;


--
-- TOC entry 4563 (class 0 OID 0)
-- Name: messages_2026_04_27_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_04_27_inserted_at_topic_idx;


--
-- TOC entry 4564 (class 0 OID 0)
-- Name: messages_2026_04_27_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_04_27_pkey;


--
-- TOC entry 4565 (class 0 OID 0)
-- Name: messages_2026_04_28_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_04_28_inserted_at_topic_idx;


--
-- TOC entry 4566 (class 0 OID 0)
-- Name: messages_2026_04_28_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_04_28_pkey;


--
-- TOC entry 4567 (class 0 OID 0)
-- Name: messages_2026_04_29_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_04_29_inserted_at_topic_idx;


--
-- TOC entry 4568 (class 0 OID 0)
-- Name: messages_2026_04_29_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_04_29_pkey;


--
-- TOC entry 4569 (class 0 OID 0)
-- Name: messages_2026_04_30_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_04_30_inserted_at_topic_idx;


--
-- TOC entry 4570 (class 0 OID 0)
-- Name: messages_2026_04_30_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_04_30_pkey;


--
-- TOC entry 4637 (class 2620 OID 17698)
-- Name: users on_auth_user_created; Type: TRIGGER; Schema: auth; Owner: supabase_auth_admin
--

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


--
-- TOC entry 4651 (class 2620 OID 18254)
-- Name: matches audit_matches_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER audit_matches_trigger AFTER INSERT OR UPDATE ON public.matches FOR EACH ROW EXECUTE FUNCTION public.audit_matches_changes();


--
-- TOC entry 4644 (class 2620 OID 18322)
-- Name: tournaments set_tournament_slug; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tournament_slug BEFORE INSERT OR UPDATE ON public.tournaments FOR EACH ROW EXECUTE FUNCTION public.generate_tournament_slug();


--
-- TOC entry 4647 (class 2620 OID 19894)
-- Name: teams trg_auto_captain; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_auto_captain AFTER INSERT ON public.teams FOR EACH ROW EXECUTE FUNCTION public.auto_add_captain_as_member();


--
-- TOC entry 4659 (class 2620 OID 18504)
-- Name: champion_masteries trg_champion_masteries_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_champion_masteries_updated_at BEFORE UPDATE ON public.champion_masteries FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4656 (class 2620 OID 19922)
-- Name: team_invites trg_expire_invite; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_expire_invite BEFORE INSERT OR UPDATE ON public.team_invites FOR EACH ROW EXECUTE FUNCTION public.expire_pending_invites();


--
-- TOC entry 4649 (class 2620 OID 19911)
-- Name: inscricoes trg_inscricao_nova; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_inscricao_nova AFTER INSERT ON public.inscricoes FOR EACH ROW EXECUTE FUNCTION public.fn_notify_inscricao();


--
-- TOC entry 4650 (class 2620 OID 19912)
-- Name: inscricoes trg_inscricao_status_change; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_inscricao_status_change AFTER UPDATE OF status ON public.inscricoes FOR EACH ROW EXECUTE FUNCTION public.fn_notify_inscricao();


--
-- TOC entry 4652 (class 2620 OID 18533)
-- Name: matches trg_match_finished; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_match_finished AFTER UPDATE ON public.matches FOR EACH ROW EXECUTE FUNCTION public.trg_match_finished();


--
-- TOC entry 4653 (class 2620 OID 17843)
-- Name: matches trg_matches_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_matches_updated_at BEFORE UPDATE ON public.matches FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4655 (class 2620 OID 18523)
-- Name: notifications trg_notifications_sync_body_message; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_notifications_sync_body_message BEFORE INSERT OR UPDATE ON public.notifications FOR EACH ROW EXECUTE FUNCTION public.sync_notifications_body_message();


--
-- TOC entry 4648 (class 2620 OID 17842)
-- Name: players trg_players_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_players_updated_at BEFORE UPDATE ON public.players FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4643 (class 2620 OID 17840)
-- Name: profiles trg_profiles_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_profiles_updated_at BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4657 (class 2620 OID 18463)
-- Name: riot_accounts trg_riot_accounts_primary; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_riot_accounts_primary BEFORE INSERT OR UPDATE ON public.riot_accounts FOR EACH ROW EXECUTE FUNCTION public.ensure_single_primary_riot_account();


--
-- TOC entry 4658 (class 2620 OID 18462)
-- Name: riot_accounts trg_riot_accounts_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_riot_accounts_updated_at BEFORE UPDATE ON public.riot_accounts FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4654 (class 2620 OID 17886)
-- Name: tournament_stages trg_stages_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_stages_updated_at BEFORE UPDATE ON public.tournament_stages FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4645 (class 2620 OID 18534)
-- Name: tournaments trg_tournament_started; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_tournament_started AFTER UPDATE ON public.tournaments FOR EACH ROW EXECUTE FUNCTION public.trg_tournament_started();


--
-- TOC entry 4646 (class 2620 OID 17841)
-- Name: tournaments trg_tournaments_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_tournaments_updated_at BEFORE UPDATE ON public.tournaments FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4642 (class 2620 OID 17402)
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- TOC entry 4638 (class 2620 OID 17288)
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- TOC entry 4639 (class 2620 OID 17352)
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- TOC entry 4640 (class 2620 OID 17353)
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- TOC entry 4641 (class 2620 OID 17222)
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- TOC entry 4572 (class 2606 OID 16691)
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4577 (class 2606 OID 16781)
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- TOC entry 4576 (class 2606 OID 16769)
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- TOC entry 4575 (class 2606 OID 16756)
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4583 (class 2606 OID 17021)
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4584 (class 2606 OID 17026)
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4585 (class 2606 OID 17050)
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4586 (class 2606 OID 17045)
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4582 (class 2606 OID 16947)
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4571 (class 2606 OID 16724)
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- TOC entry 4579 (class 2606 OID 16828)
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4580 (class 2606 OID 16901)
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- TOC entry 4581 (class 2606 OID 16842)
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4573 (class 2606 OID 17064)
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4574 (class 2606 OID 16719)
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4578 (class 2606 OID 16809)
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4588 (class 2606 OID 17157)
-- Name: webauthn_challenges webauthn_challenges_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4587 (class 2606 OID 17140)
-- Name: webauthn_credentials webauthn_credentials_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4635 (class 2606 OID 19871)
-- Name: active_team active_team_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_team
    ADD CONSTRAINT active_team_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- TOC entry 4636 (class 2606 OID 19876)
-- Name: active_team active_team_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_team
    ADD CONSTRAINT active_team_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE SET NULL;


--
-- TOC entry 4626 (class 2606 OID 18242)
-- Name: audit_log audit_log_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- TOC entry 4629 (class 2606 OID 18498)
-- Name: champion_masteries champion_masteries_riot_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.champion_masteries
    ADD CONSTRAINT champion_masteries_riot_account_id_fkey FOREIGN KEY (riot_account_id) REFERENCES public.riot_accounts(id) ON DELETE CASCADE;


--
-- TOC entry 4622 (class 2606 OID 18200)
-- Name: disputes disputes_match_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disputes
    ADD CONSTRAINT disputes_match_id_fkey FOREIGN KEY (match_id) REFERENCES public.matches(id) ON DELETE CASCADE;


--
-- TOC entry 4623 (class 2606 OID 18205)
-- Name: disputes disputes_reported_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disputes
    ADD CONSTRAINT disputes_reported_by_fkey FOREIGN KEY (reported_by) REFERENCES public.profiles(id);


--
-- TOC entry 4624 (class 2606 OID 18210)
-- Name: disputes disputes_resolved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disputes
    ADD CONSTRAINT disputes_resolved_by_fkey FOREIGN KEY (resolved_by) REFERENCES public.profiles(id);


--
-- TOC entry 4600 (class 2606 OID 19798)
-- Name: inscricoes inscricoes_checked_in_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inscricoes
    ADD CONSTRAINT inscricoes_checked_in_by_fkey FOREIGN KEY (checked_in_by) REFERENCES auth.users(id);


--
-- TOC entry 4601 (class 2606 OID 17791)
-- Name: inscricoes inscricoes_requested_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inscricoes
    ADD CONSTRAINT inscricoes_requested_by_fkey FOREIGN KEY (requested_by) REFERENCES public.profiles(id) ON DELETE SET NULL;


--
-- TOC entry 4602 (class 2606 OID 17796)
-- Name: inscricoes inscricoes_reviewed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inscricoes
    ADD CONSTRAINT inscricoes_reviewed_by_fkey FOREIGN KEY (reviewed_by) REFERENCES public.profiles(id) ON DELETE SET NULL;


--
-- TOC entry 4603 (class 2606 OID 17786)
-- Name: inscricoes inscricoes_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inscricoes
    ADD CONSTRAINT inscricoes_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE;


--
-- TOC entry 4604 (class 2606 OID 17781)
-- Name: inscricoes inscricoes_tournament_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inscricoes
    ADD CONSTRAINT inscricoes_tournament_id_fkey FOREIGN KEY (tournament_id) REFERENCES public.tournaments(id) ON DELETE CASCADE;


--
-- TOC entry 4611 (class 2606 OID 17908)
-- Name: match_games match_games_match_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_games
    ADD CONSTRAINT match_games_match_id_fkey FOREIGN KEY (match_id) REFERENCES public.matches(id) ON DELETE CASCADE;


--
-- TOC entry 4612 (class 2606 OID 17913)
-- Name: match_games match_games_winner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_games
    ADD CONSTRAINT match_games_winner_id_fkey FOREIGN KEY (winner_id) REFERENCES public.teams(id) ON DELETE SET NULL;


--
-- TOC entry 4605 (class 2606 OID 17889)
-- Name: matches matches_stage_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_stage_id_fkey FOREIGN KEY (stage_id) REFERENCES public.tournament_stages(id) ON DELETE SET NULL;


--
-- TOC entry 4606 (class 2606 OID 17822)
-- Name: matches matches_team_a_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_team_a_id_fkey FOREIGN KEY (team_a_id) REFERENCES public.teams(id) ON DELETE SET NULL;


--
-- TOC entry 4607 (class 2606 OID 17827)
-- Name: matches matches_team_b_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_team_b_id_fkey FOREIGN KEY (team_b_id) REFERENCES public.teams(id) ON DELETE SET NULL;


--
-- TOC entry 4608 (class 2606 OID 17817)
-- Name: matches matches_tournament_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_tournament_id_fkey FOREIGN KEY (tournament_id) REFERENCES public.tournaments(id) ON DELETE CASCADE;


--
-- TOC entry 4609 (class 2606 OID 17832)
-- Name: matches matches_winner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_winner_id_fkey FOREIGN KEY (winner_id) REFERENCES public.teams(id) ON DELETE SET NULL;


--
-- TOC entry 4616 (class 2606 OID 18517)
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- TOC entry 4613 (class 2606 OID 17941)
-- Name: player_stats player_stats_game_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.player_stats
    ADD CONSTRAINT player_stats_game_id_fkey FOREIGN KEY (game_id) REFERENCES public.match_games(id) ON DELETE CASCADE;


--
-- TOC entry 4614 (class 2606 OID 17946)
-- Name: player_stats player_stats_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.player_stats
    ADD CONSTRAINT player_stats_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.players(id) ON DELETE SET NULL;


--
-- TOC entry 4615 (class 2606 OID 17951)
-- Name: player_stats player_stats_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.player_stats
    ADD CONSTRAINT player_stats_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE SET NULL;


--
-- TOC entry 4599 (class 2606 OID 17761)
-- Name: players players_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE SET NULL;


--
-- TOC entry 4617 (class 2606 OID 18116)
-- Name: prize_distribution prize_distribution_tournament_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prize_distribution
    ADD CONSTRAINT prize_distribution_tournament_id_fkey FOREIGN KEY (tournament_id) REFERENCES public.tournaments(id) ON DELETE CASCADE;


--
-- TOC entry 4594 (class 2606 OID 17692)
-- Name: profiles profiles_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4628 (class 2606 OID 18477)
-- Name: rank_snapshots rank_snapshots_riot_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rank_snapshots
    ADD CONSTRAINT rank_snapshots_riot_account_id_fkey FOREIGN KEY (riot_account_id) REFERENCES public.riot_accounts(id) ON DELETE CASCADE;


--
-- TOC entry 4627 (class 2606 OID 18453)
-- Name: riot_accounts riot_accounts_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.riot_accounts
    ADD CONSTRAINT riot_accounts_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- TOC entry 4618 (class 2606 OID 18142)
-- Name: seedings seedings_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seedings
    ADD CONSTRAINT seedings_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE;


--
-- TOC entry 4619 (class 2606 OID 18137)
-- Name: seedings seedings_tournament_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seedings
    ADD CONSTRAINT seedings_tournament_id_fkey FOREIGN KEY (tournament_id) REFERENCES public.tournaments(id) ON DELETE CASCADE;


--
-- TOC entry 4630 (class 2606 OID 18763)
-- Name: site_terms_acceptance site_terms_acceptance_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.site_terms_acceptance
    ADD CONSTRAINT site_terms_acceptance_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- TOC entry 4620 (class 2606 OID 18174)
-- Name: team_invites team_invites_invited_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_invites
    ADD CONSTRAINT team_invites_invited_by_fkey FOREIGN KEY (invited_by) REFERENCES public.profiles(id);


--
-- TOC entry 4621 (class 2606 OID 18169)
-- Name: team_invites team_invites_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_invites
    ADD CONSTRAINT team_invites_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE;


--
-- TOC entry 4631 (class 2606 OID 19857)
-- Name: team_members team_members_invited_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT team_members_invited_by_fkey FOREIGN KEY (invited_by) REFERENCES public.profiles(id) ON DELETE SET NULL;


--
-- TOC entry 4632 (class 2606 OID 19847)
-- Name: team_members team_members_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT team_members_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- TOC entry 4633 (class 2606 OID 19852)
-- Name: team_members team_members_riot_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT team_members_riot_account_id_fkey FOREIGN KEY (riot_account_id) REFERENCES public.riot_accounts(id) ON DELETE SET NULL;


--
-- TOC entry 4634 (class 2606 OID 19842)
-- Name: team_members team_members_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT team_members_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE;


--
-- TOC entry 4597 (class 2606 OID 17735)
-- Name: teams teams_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.profiles(id) ON DELETE SET NULL;


--
-- TOC entry 4598 (class 2606 OID 17730)
-- Name: teams teams_tournament_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_tournament_id_fkey FOREIGN KEY (tournament_id) REFERENCES public.tournaments(id) ON DELETE CASCADE;


--
-- TOC entry 4625 (class 2606 OID 18225)
-- Name: tournament_rules tournament_rules_tournament_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tournament_rules
    ADD CONSTRAINT tournament_rules_tournament_id_fkey FOREIGN KEY (tournament_id) REFERENCES public.tournaments(id) ON DELETE CASCADE;


--
-- TOC entry 4610 (class 2606 OID 17880)
-- Name: tournament_stages tournament_stages_tournament_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tournament_stages
    ADD CONSTRAINT tournament_stages_tournament_id_fkey FOREIGN KEY (tournament_id) REFERENCES public.tournaments(id) ON DELETE CASCADE;


--
-- TOC entry 4595 (class 2606 OID 17713)
-- Name: tournaments tournaments_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tournaments
    ADD CONSTRAINT tournaments_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(id) ON DELETE SET NULL;


--
-- TOC entry 4596 (class 2606 OID 18774)
-- Name: tournaments tournaments_organizer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tournaments
    ADD CONSTRAINT tournaments_organizer_id_fkey FOREIGN KEY (organizer_id) REFERENCES public.profiles(id) ON DELETE SET NULL;


--
-- TOC entry 4589 (class 2606 OID 17197)
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4590 (class 2606 OID 17244)
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4591 (class 2606 OID 17264)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4592 (class 2606 OID 17259)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- TOC entry 4593 (class 2606 OID 17329)
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- TOC entry 4814 (class 0 OID 16529)
-- Dependencies: 332
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4825 (class 0 OID 16887)
-- Dependencies: 345
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4816 (class 0 OID 16684)
-- Dependencies: 336
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4813 (class 0 OID 16522)
-- Dependencies: 331
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4820 (class 0 OID 16774)
-- Dependencies: 340
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4819 (class 0 OID 16762)
-- Dependencies: 339
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4818 (class 0 OID 16749)
-- Dependencies: 338
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4826 (class 0 OID 16937)
-- Dependencies: 346
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4812 (class 0 OID 16511)
-- Dependencies: 330
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4823 (class 0 OID 16816)
-- Dependencies: 343
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4824 (class 0 OID 16834)
-- Dependencies: 344
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4815 (class 0 OID 16537)
-- Dependencies: 333
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4817 (class 0 OID 16714)
-- Dependencies: 337
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4822 (class 0 OID 16801)
-- Dependencies: 342
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4821 (class 0 OID 16792)
-- Dependencies: 341
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4811 (class 0 OID 16499)
-- Dependencies: 328
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4906 (class 3256 OID 18347)
-- Name: seedings Admins can manage seedings; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can manage seedings" ON public.seedings USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.id = auth.uid()) AND (profiles.is_admin = true)))));


--
-- TOC entry 4882 (class 3256 OID 18247)
-- Name: audit_log Admins can view audit log; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can view audit log" ON public.audit_log FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.id = auth.uid()) AND (profiles.is_admin = true)))));


--
-- TOC entry 4905 (class 3256 OID 18346)
-- Name: seedings Public can view seedings; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Public can view seedings" ON public.seedings FOR SELECT USING (true);


--
-- TOC entry 4857 (class 0 OID 19865)
-- Dependencies: 405
-- Name: active_team; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.active_team ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4937 (class 3256 OID 19885)
-- Name: active_team active_team_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY active_team_select ON public.active_team FOR SELECT USING ((profile_id = auth.uid()));


--
-- TOC entry 4938 (class 3256 OID 19886)
-- Name: active_team active_team_upsert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY active_team_upsert ON public.active_team USING ((profile_id = auth.uid()));


--
-- TOC entry 4919 (class 3256 OID 18730)
-- Name: profiles admin_read_all_profiles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY admin_read_all_profiles ON public.profiles FOR SELECT USING (public.is_admin(auth.uid()));


--
-- TOC entry 4930 (class 3256 OID 18771)
-- Name: site_terms_acceptance admin_select_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY admin_select_all ON public.site_terms_acceptance FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.id = auth.uid()) AND (profiles.is_admin = true)))));


--
-- TOC entry 4851 (class 0 OID 18233)
-- Dependencies: 384
-- Name: audit_log; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.audit_log ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4903 (class 3256 OID 18316)
-- Name: audit_log audit_log_insert_service_role; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY audit_log_insert_service_role ON public.audit_log FOR INSERT WITH CHECK ((auth.role() = 'service_role'::text));


--
-- TOC entry 4854 (class 0 OID 18484)
-- Dependencies: 396
-- Name: champion_masteries; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.champion_masteries ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4920 (class 3256 OID 18515)
-- Name: champion_masteries champion_masteries_delete_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY champion_masteries_delete_own ON public.champion_masteries FOR DELETE USING ((EXISTS ( SELECT 1
   FROM public.riot_accounts ra
  WHERE ((ra.id = champion_masteries.riot_account_id) AND (ra.profile_id = auth.uid())))));


--
-- TOC entry 4917 (class 3256 OID 18512)
-- Name: champion_masteries champion_masteries_insert_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY champion_masteries_insert_own ON public.champion_masteries FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM public.riot_accounts ra
  WHERE ((ra.id = champion_masteries.riot_account_id) AND (ra.profile_id = auth.uid())))));


--
-- TOC entry 4916 (class 3256 OID 18511)
-- Name: champion_masteries champion_masteries_select_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY champion_masteries_select_own ON public.champion_masteries FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.riot_accounts ra
  WHERE ((ra.id = champion_masteries.riot_account_id) AND (ra.profile_id = auth.uid())))));


--
-- TOC entry 4918 (class 3256 OID 18513)
-- Name: champion_masteries champion_masteries_update_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY champion_masteries_update_own ON public.champion_masteries FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM public.riot_accounts ra
  WHERE ((ra.id = champion_masteries.riot_account_id) AND (ra.profile_id = auth.uid()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.riot_accounts ra
  WHERE ((ra.id = champion_masteries.riot_account_id) AND (ra.profile_id = auth.uid())))));


--
-- TOC entry 4849 (class 0 OID 18189)
-- Dependencies: 382
-- Name: disputes; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.disputes ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4899 (class 3256 OID 18301)
-- Name: disputes disputes_delete_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY disputes_delete_admin ON public.disputes FOR DELETE USING (public.is_admin(auth.uid()));


--
-- TOC entry 4897 (class 3256 OID 18299)
-- Name: disputes disputes_insert_auth; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY disputes_insert_auth ON public.disputes FOR INSERT WITH CHECK ((auth.uid() = reported_by));


--
-- TOC entry 4896 (class 3256 OID 18298)
-- Name: disputes disputes_select_auth; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY disputes_select_auth ON public.disputes FOR SELECT USING ((auth.role() = 'authenticated'::text));


--
-- TOC entry 4898 (class 3256 OID 18300)
-- Name: disputes disputes_update_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY disputes_update_admin ON public.disputes FOR UPDATE USING (public.is_admin(auth.uid()));


--
-- TOC entry 4840 (class 0 OID 17769)
-- Dependencies: 373
-- Name: inscricoes; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.inscricoes ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4873 (class 3256 OID 17863)
-- Name: inscricoes inscricoes_delete_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY inscricoes_delete_admin ON public.inscricoes FOR DELETE USING (public.is_admin(auth.uid()));


--
-- TOC entry 4948 (class 3256 OID 19901)
-- Name: inscricoes inscricoes_insert_owner; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY inscricoes_insert_owner ON public.inscricoes FOR INSERT WITH CHECK ((auth.uid() = requested_by));


--
-- TOC entry 4872 (class 3256 OID 17861)
-- Name: inscricoes inscricoes_insert_user; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY inscricoes_insert_user ON public.inscricoes FOR INSERT WITH CHECK ((auth.uid() = requested_by));


--
-- TOC entry 4871 (class 3256 OID 17860)
-- Name: inscricoes inscricoes_select_auth; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY inscricoes_select_auth ON public.inscricoes FOR SELECT USING ((auth.role() = 'authenticated'::text));


--
-- TOC entry 4935 (class 3256 OID 19899)
-- Name: inscricoes inscricoes_select_authenticated; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY inscricoes_select_authenticated ON public.inscricoes FOR SELECT USING ((auth.uid() IS NOT NULL));


--
-- TOC entry 4944 (class 3256 OID 19892)
-- Name: inscricoes inscricoes_update_organizer_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY inscricoes_update_organizer_or_admin ON public.inscricoes FOR UPDATE USING ((public.is_admin(auth.uid()) OR public.is_tournament_organizer(auth.uid(), tournament_id)));


--
-- TOC entry 4947 (class 3256 OID 19900)
-- Name: inscricoes inscricoes_update_owner_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY inscricoes_update_owner_or_admin ON public.inscricoes FOR UPDATE USING (((auth.uid() = requested_by) OR public.is_current_user_admin()));


--
-- TOC entry 4843 (class 0 OID 17895)
-- Dependencies: 376
-- Name: match_games; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.match_games ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4879 (class 3256 OID 17998)
-- Name: match_games match_games_all_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY match_games_all_admin ON public.match_games USING (public.is_admin(auth.uid()));


--
-- TOC entry 4878 (class 3256 OID 17997)
-- Name: match_games match_games_select_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY match_games_select_all ON public.match_games FOR SELECT USING (true);


--
-- TOC entry 4841 (class 0 OID 17801)
-- Dependencies: 374
-- Name: matches; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.matches ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4875 (class 3256 OID 17865)
-- Name: matches matches_all_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY matches_all_admin ON public.matches USING (public.is_admin(auth.uid()));


--
-- TOC entry 4950 (class 3256 OID 19906)
-- Name: matches matches_read_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY matches_read_all ON public.matches FOR SELECT USING (true);


--
-- TOC entry 4874 (class 3256 OID 17864)
-- Name: matches matches_select_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY matches_select_all ON public.matches FOR SELECT USING (true);


--
-- TOC entry 4951 (class 3256 OID 19907)
-- Name: matches matches_write_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY matches_write_admin ON public.matches USING (((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.id = auth.uid()) AND (profiles.is_admin = true)))) OR (EXISTS ( SELECT 1
   FROM public.tournaments t
  WHERE ((t.id = matches.tournament_id) AND (t.organizer_id = auth.uid()))))));


--
-- TOC entry 4845 (class 0 OID 17977)
-- Dependencies: 378
-- Name: notifications; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4924 (class 3256 OID 18529)
-- Name: notifications notifications_delete_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY notifications_delete_own ON public.notifications FOR DELETE USING ((auth.uid() = user_id));


--
-- TOC entry 4922 (class 3256 OID 18527)
-- Name: notifications notifications_insert_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY notifications_insert_own ON public.notifications FOR INSERT WITH CHECK (((auth.uid() = user_id) OR (auth.role() = 'service_role'::text)));


--
-- TOC entry 4904 (class 3256 OID 18317)
-- Name: notifications notifications_insert_service_role; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY notifications_insert_service_role ON public.notifications FOR INSERT WITH CHECK ((auth.role() = 'service_role'::text));


--
-- TOC entry 4921 (class 3256 OID 18526)
-- Name: notifications notifications_select_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY notifications_select_own ON public.notifications FOR SELECT USING ((auth.uid() = user_id));


--
-- TOC entry 4923 (class 3256 OID 18528)
-- Name: notifications notifications_update_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY notifications_update_own ON public.notifications FOR UPDATE USING ((auth.uid() = user_id)) WITH CHECK ((auth.uid() = user_id));


--
-- TOC entry 4928 (class 3256 OID 18770)
-- Name: site_terms_acceptance owner_insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY owner_insert ON public.site_terms_acceptance FOR INSERT WITH CHECK ((profile_id = auth.uid()));


--
-- TOC entry 4927 (class 3256 OID 18769)
-- Name: site_terms_acceptance owner_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY owner_select ON public.site_terms_acceptance FOR SELECT USING ((profile_id = auth.uid()));


--
-- TOC entry 4844 (class 0 OID 17919)
-- Dependencies: 377
-- Name: player_stats; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.player_stats ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4881 (class 3256 OID 18000)
-- Name: player_stats player_stats_all_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY player_stats_all_admin ON public.player_stats USING (public.is_admin(auth.uid()));


--
-- TOC entry 4880 (class 3256 OID 17999)
-- Name: player_stats player_stats_select_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY player_stats_select_all ON public.player_stats FOR SELECT USING (true);


--
-- TOC entry 4839 (class 0 OID 17740)
-- Dependencies: 372
-- Name: players; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.players ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4870 (class 3256 OID 17859)
-- Name: players players_delete_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY players_delete_admin ON public.players FOR DELETE USING (public.is_admin(auth.uid()));


--
-- TOC entry 4868 (class 3256 OID 17857)
-- Name: players players_insert_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY players_insert_admin ON public.players FOR INSERT WITH CHECK (public.is_admin(auth.uid()));


--
-- TOC entry 4867 (class 3256 OID 17856)
-- Name: players players_select_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY players_select_all ON public.players FOR SELECT USING (true);


--
-- TOC entry 4869 (class 3256 OID 17858)
-- Name: players players_update_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY players_update_admin ON public.players FOR UPDATE USING (public.is_admin(auth.uid()));


--
-- TOC entry 4949 (class 3256 OID 19902)
-- Name: players players_update_team_owner; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY players_update_team_owner ON public.players FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM public.teams
  WHERE ((teams.id = players.team_id) AND (teams.owner_id = auth.uid())))));


--
-- TOC entry 4887 (class 3256 OID 18289)
-- Name: prize_distribution prize_dist_delete_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY prize_dist_delete_admin ON public.prize_distribution FOR DELETE USING (public.is_admin(auth.uid()));


--
-- TOC entry 4885 (class 3256 OID 18287)
-- Name: prize_distribution prize_dist_insert_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY prize_dist_insert_admin ON public.prize_distribution FOR INSERT WITH CHECK (public.is_admin(auth.uid()));


--
-- TOC entry 4884 (class 3256 OID 18286)
-- Name: prize_distribution prize_dist_select_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY prize_dist_select_all ON public.prize_distribution FOR SELECT USING (true);


--
-- TOC entry 4886 (class 3256 OID 18288)
-- Name: prize_distribution prize_dist_update_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY prize_dist_update_admin ON public.prize_distribution FOR UPDATE USING (public.is_admin(auth.uid()));


--
-- TOC entry 4846 (class 0 OID 18106)
-- Dependencies: 379
-- Name: prize_distribution; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.prize_distribution ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4836 (class 0 OID 17681)
-- Dependencies: 369
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4925 (class 3256 OID 18626)
-- Name: profiles profiles_count_public; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY profiles_count_public ON public.profiles FOR SELECT USING (true);


--
-- TOC entry 4859 (class 3256 OID 17845)
-- Name: profiles profiles_select_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY profiles_select_all ON public.profiles FOR SELECT USING (true);


--
-- TOC entry 4913 (class 3256 OID 18729)
-- Name: profiles profiles_select_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY profiles_select_own ON public.profiles FOR SELECT USING ((auth.uid() = id));


--
-- TOC entry 4861 (class 3256 OID 17847)
-- Name: profiles profiles_update_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY profiles_update_admin ON public.profiles FOR UPDATE USING (public.is_admin(auth.uid()));


--
-- TOC entry 4860 (class 3256 OID 17846)
-- Name: profiles profiles_update_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY profiles_update_own ON public.profiles FOR UPDATE USING ((auth.uid() = id));


--
-- TOC entry 4853 (class 0 OID 18464)
-- Dependencies: 395
-- Name: rank_snapshots; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.rank_snapshots ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4915 (class 3256 OID 18510)
-- Name: rank_snapshots rank_snapshots_insert_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY rank_snapshots_insert_own ON public.rank_snapshots FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM public.riot_accounts ra
  WHERE ((ra.id = rank_snapshots.riot_account_id) AND (ra.profile_id = auth.uid())))));


--
-- TOC entry 4914 (class 3256 OID 18509)
-- Name: rank_snapshots rank_snapshots_select_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY rank_snapshots_select_own ON public.rank_snapshots FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.riot_accounts ra
  WHERE ((ra.id = rank_snapshots.riot_account_id) AND (ra.profile_id = auth.uid())))));


--
-- TOC entry 4852 (class 0 OID 18442)
-- Dependencies: 394
-- Name: riot_accounts; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.riot_accounts ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4926 (class 3256 OID 18631)
-- Name: riot_accounts riot_accounts_count_public; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY riot_accounts_count_public ON public.riot_accounts FOR SELECT USING (true);


--
-- TOC entry 4912 (class 3256 OID 18508)
-- Name: riot_accounts riot_accounts_delete_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY riot_accounts_delete_own ON public.riot_accounts FOR DELETE USING ((auth.uid() = profile_id));


--
-- TOC entry 4910 (class 3256 OID 18506)
-- Name: riot_accounts riot_accounts_insert_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY riot_accounts_insert_own ON public.riot_accounts FOR INSERT WITH CHECK ((auth.uid() = profile_id));


--
-- TOC entry 4909 (class 3256 OID 18505)
-- Name: riot_accounts riot_accounts_select_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY riot_accounts_select_own ON public.riot_accounts FOR SELECT USING ((auth.uid() = profile_id));


--
-- TOC entry 4911 (class 3256 OID 18507)
-- Name: riot_accounts riot_accounts_update_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY riot_accounts_update_own ON public.riot_accounts FOR UPDATE USING ((auth.uid() = profile_id)) WITH CHECK ((auth.uid() = profile_id));


--
-- TOC entry 4902 (class 3256 OID 18305)
-- Name: tournament_rules rules_delete_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY rules_delete_admin ON public.tournament_rules FOR DELETE USING (public.is_admin(auth.uid()));


--
-- TOC entry 4883 (class 3256 OID 18303)
-- Name: tournament_rules rules_insert_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY rules_insert_admin ON public.tournament_rules FOR INSERT WITH CHECK (public.is_admin(auth.uid()));


--
-- TOC entry 4900 (class 3256 OID 18302)
-- Name: tournament_rules rules_select_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY rules_select_all ON public.tournament_rules FOR SELECT USING (true);


--
-- TOC entry 4901 (class 3256 OID 18304)
-- Name: tournament_rules rules_update_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY rules_update_admin ON public.tournament_rules FOR UPDATE USING (public.is_admin(auth.uid()));


--
-- TOC entry 4847 (class 0 OID 18121)
-- Dependencies: 380
-- Name: seedings; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.seedings ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4891 (class 3256 OID 18293)
-- Name: seedings seedings_delete_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY seedings_delete_admin ON public.seedings FOR DELETE USING (public.is_admin(auth.uid()));


--
-- TOC entry 4889 (class 3256 OID 18291)
-- Name: seedings seedings_insert_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY seedings_insert_admin ON public.seedings FOR INSERT WITH CHECK (public.is_admin(auth.uid()));


--
-- TOC entry 4888 (class 3256 OID 18290)
-- Name: seedings seedings_select_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY seedings_select_all ON public.seedings FOR SELECT USING (true);


--
-- TOC entry 4890 (class 3256 OID 18292)
-- Name: seedings seedings_update_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY seedings_update_admin ON public.seedings FOR UPDATE USING (public.is_admin(auth.uid()));


--
-- TOC entry 4855 (class 0 OID 18751)
-- Dependencies: 402
-- Name: site_terms_acceptance; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.site_terms_acceptance ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4877 (class 3256 OID 17996)
-- Name: tournament_stages stages_all_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY stages_all_admin ON public.tournament_stages USING (public.is_admin(auth.uid()));


--
-- TOC entry 4876 (class 3256 OID 17995)
-- Name: tournament_stages stages_select_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY stages_select_all ON public.tournament_stages FOR SELECT USING (true);


--
-- TOC entry 4848 (class 0 OID 18157)
-- Dependencies: 381
-- Name: team_invites; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.team_invites ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4955 (class 3256 OID 19919)
-- Name: team_invites team_invites_delete; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY team_invites_delete ON public.team_invites FOR DELETE USING ((public.is_admin(auth.uid()) OR (team_id IN ( SELECT teams.id
   FROM public.teams
  WHERE (teams.owner_id = auth.uid())))));


--
-- TOC entry 4895 (class 3256 OID 18297)
-- Name: team_invites team_invites_delete_owner_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY team_invites_delete_owner_or_admin ON public.team_invites FOR DELETE USING ((public.is_admin(auth.uid()) OR (auth.uid() IN ( SELECT teams.owner_id
   FROM public.teams
  WHERE (teams.id = team_invites.team_id)))));


--
-- TOC entry 4953 (class 3256 OID 19917)
-- Name: team_invites team_invites_insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY team_invites_insert ON public.team_invites FOR INSERT WITH CHECK ((public.is_admin(auth.uid()) OR (team_id IN ( SELECT teams.id
   FROM public.teams
  WHERE (teams.owner_id = auth.uid())))));


--
-- TOC entry 4893 (class 3256 OID 18295)
-- Name: team_invites team_invites_insert_owner_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY team_invites_insert_owner_or_admin ON public.team_invites FOR INSERT WITH CHECK ((public.is_admin(auth.uid()) OR (auth.uid() IN ( SELECT teams.owner_id
   FROM public.teams
  WHERE (teams.id = team_invites.team_id)))));


--
-- TOC entry 4952 (class 3256 OID 19916)
-- Name: team_invites team_invites_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY team_invites_select ON public.team_invites FOR SELECT USING ((public.is_admin(auth.uid()) OR (team_id IN ( SELECT teams.id
   FROM public.teams
  WHERE (teams.owner_id = auth.uid()))) OR (invited_by = auth.uid())));


--
-- TOC entry 4892 (class 3256 OID 18294)
-- Name: team_invites team_invites_select_owner_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY team_invites_select_owner_or_admin ON public.team_invites FOR SELECT USING ((public.is_admin(auth.uid()) OR (auth.uid() IN ( SELECT teams.owner_id
   FROM public.teams
  WHERE (teams.id = team_invites.team_id)))));


--
-- TOC entry 4954 (class 3256 OID 19918)
-- Name: team_invites team_invites_update; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY team_invites_update ON public.team_invites FOR UPDATE USING ((public.is_admin(auth.uid()) OR (team_id IN ( SELECT teams.id
   FROM public.teams
  WHERE (teams.owner_id = auth.uid())))));


--
-- TOC entry 4894 (class 3256 OID 18296)
-- Name: team_invites team_invites_update_owner_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY team_invites_update_owner_or_admin ON public.team_invites FOR UPDATE USING ((public.is_admin(auth.uid()) OR (auth.uid() IN ( SELECT teams.owner_id
   FROM public.teams
  WHERE (teams.id = team_invites.team_id)))));


--
-- TOC entry 4856 (class 0 OID 19831)
-- Dependencies: 404
-- Name: team_members; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.team_members ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4936 (class 3256 OID 19884)
-- Name: team_members team_members_delete; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY team_members_delete ON public.team_members FOR DELETE USING ((public.is_admin(auth.uid()) OR (team_id IN ( SELECT teams.id
   FROM public.teams
  WHERE (teams.owner_id = auth.uid()))) OR (profile_id = auth.uid())));


--
-- TOC entry 4933 (class 3256 OID 19882)
-- Name: team_members team_members_insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY team_members_insert ON public.team_members FOR INSERT WITH CHECK ((public.is_admin(auth.uid()) OR (team_id IN ( SELECT teams.id
   FROM public.teams
  WHERE (teams.owner_id = auth.uid())))));


--
-- TOC entry 4932 (class 3256 OID 19881)
-- Name: team_members team_members_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY team_members_select ON public.team_members FOR SELECT USING (((auth.role() = 'authenticated'::text) AND (public.is_admin(auth.uid()) OR (profile_id = auth.uid()) OR (team_id IN ( SELECT teams.id
   FROM public.teams
  WHERE (teams.owner_id = auth.uid()))) OR (team_id IN ( SELECT team_members_1.team_id
   FROM public.team_members team_members_1
  WHERE ((team_members_1.profile_id = auth.uid()) AND (team_members_1.status = 'accepted'::public.team_member_status)))))));


--
-- TOC entry 4934 (class 3256 OID 19883)
-- Name: team_members team_members_update; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY team_members_update ON public.team_members FOR UPDATE USING ((public.is_admin(auth.uid()) OR (team_id IN ( SELECT teams.id
   FROM public.teams
  WHERE (teams.owner_id = auth.uid()))) OR ((profile_id = auth.uid()) AND (status = 'pending'::public.team_member_status))));


--
-- TOC entry 4838 (class 0 OID 17718)
-- Dependencies: 371
-- Name: teams; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.teams ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4866 (class 3256 OID 17855)
-- Name: teams teams_delete_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY teams_delete_admin ON public.teams FOR DELETE USING (public.is_admin(auth.uid()));


--
-- TOC entry 4946 (class 3256 OID 19897)
-- Name: teams teams_delete_owner; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY teams_delete_owner ON public.teams FOR DELETE USING ((auth.uid() = owner_id));


--
-- TOC entry 4929 (class 3256 OID 19898)
-- Name: teams teams_insert_authenticated; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY teams_insert_authenticated ON public.teams FOR INSERT WITH CHECK ((auth.uid() = owner_id));


--
-- TOC entry 4864 (class 3256 OID 17853)
-- Name: teams teams_insert_owner_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY teams_insert_owner_or_admin ON public.teams FOR INSERT WITH CHECK (((auth.uid() = owner_id) OR public.is_admin(auth.uid())));


--
-- TOC entry 4863 (class 3256 OID 17852)
-- Name: teams teams_select_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY teams_select_all ON public.teams FOR SELECT USING (true);


--
-- TOC entry 4945 (class 3256 OID 19896)
-- Name: teams teams_update_owner; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY teams_update_owner ON public.teams FOR UPDATE USING ((auth.uid() = owner_id));


--
-- TOC entry 4865 (class 3256 OID 17854)
-- Name: teams teams_update_owner_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY teams_update_owner_or_admin ON public.teams FOR UPDATE USING (((auth.uid() = owner_id) OR public.is_admin(auth.uid())));


--
-- TOC entry 4940 (class 3256 OID 19888)
-- Name: site_terms_acceptance terms_insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY terms_insert ON public.site_terms_acceptance FOR INSERT WITH CHECK ((profile_id = auth.uid()));


--
-- TOC entry 4939 (class 3256 OID 19887)
-- Name: site_terms_acceptance terms_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY terms_select ON public.site_terms_acceptance FOR SELECT USING ((profile_id = auth.uid()));


--
-- TOC entry 4858 (class 0 OID 19923)
-- Dependencies: 406
-- Name: tournament_match_results; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.tournament_match_results ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4850 (class 0 OID 18215)
-- Dependencies: 383
-- Name: tournament_rules; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.tournament_rules ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4842 (class 0 OID 17867)
-- Dependencies: 375
-- Name: tournament_stages; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.tournament_stages ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4837 (class 0 OID 17699)
-- Dependencies: 370
-- Name: tournaments; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.tournaments ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4943 (class 3256 OID 19891)
-- Name: tournaments tournaments_delete_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY tournaments_delete_admin ON public.tournaments FOR DELETE USING (public.is_admin(auth.uid()));


--
-- TOC entry 4931 (class 3256 OID 18780)
-- Name: tournaments tournaments_insert_organizer; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY tournaments_insert_organizer ON public.tournaments FOR INSERT TO authenticated WITH CHECK (((organizer_id = auth.uid()) AND (created_by = auth.uid()) AND (NOT (EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.id = auth.uid()) AND (profiles.is_banned = true)))))));


--
-- TOC entry 4941 (class 3256 OID 19889)
-- Name: tournaments tournaments_insert_organizer_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY tournaments_insert_organizer_or_admin ON public.tournaments FOR INSERT WITH CHECK (public.is_organizer_or_admin(auth.uid()));


--
-- TOC entry 4862 (class 3256 OID 17848)
-- Name: tournaments tournaments_select_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY tournaments_select_all ON public.tournaments FOR SELECT USING (true);


--
-- TOC entry 4942 (class 3256 OID 19890)
-- Name: tournaments tournaments_update_organizer_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY tournaments_update_organizer_or_admin ON public.tournaments FOR UPDATE USING ((public.is_admin(auth.uid()) OR ((auth.uid() = organizer_id) AND public.is_organizer_or_admin(auth.uid()))));


--
-- TOC entry 4907 (class 3256 OID 18434)
-- Name: notifications users_see_own_notifications; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY users_see_own_notifications ON public.notifications FOR SELECT USING ((auth.uid() = user_id));


--
-- TOC entry 4908 (class 3256 OID 18435)
-- Name: notifications users_update_own_notifications; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY users_update_own_notifications ON public.notifications FOR UPDATE USING ((auth.uid() = user_id));


--
-- TOC entry 4835 (class 0 OID 17529)
-- Dependencies: 368
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4828 (class 0 OID 17176)
-- Dependencies: 355
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4832 (class 0 OID 17296)
-- Dependencies: 359
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4833 (class 0 OID 17309)
-- Dependencies: 360
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4827 (class 0 OID 17168)
-- Dependencies: 354
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4829 (class 0 OID 17186)
-- Dependencies: 356
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4830 (class 0 OID 17235)
-- Dependencies: 357
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4831 (class 0 OID 17249)
-- Dependencies: 358
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4834 (class 0 OID 17319)
-- Dependencies: 361
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4956 (class 6104 OID 16430)
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- TOC entry 4957 (class 6104 OID 18602)
-- Name: supabase_realtime_messages_publication; Type: PUBLICATION; Schema: -; Owner: supabase_admin
--

CREATE PUBLICATION supabase_realtime_messages_publication WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime_messages_publication OWNER TO supabase_admin;

--
-- TOC entry 4958 (class 6106 OID 18436)
-- Name: supabase_realtime notifications; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.notifications;


--
-- TOC entry 4959 (class 6106 OID 18603)
-- Name: supabase_realtime_messages_publication messages; Type: PUBLICATION TABLE; Schema: realtime; Owner: supabase_admin
--

ALTER PUBLICATION supabase_realtime_messages_publication ADD TABLE ONLY realtime.messages;


--
-- TOC entry 4965 (class 0 OID 0)
-- Dependencies: 39
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT USAGE ON SCHEMA auth TO postgres;


--
-- TOC entry 4966 (class 0 OID 0)
-- Dependencies: 25
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- TOC entry 4968 (class 0 OID 0)
-- Dependencies: 72
-- Name: SCHEMA net; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA net TO supabase_functions_admin;
GRANT USAGE ON SCHEMA net TO postgres;
GRANT USAGE ON SCHEMA net TO anon;
GRANT USAGE ON SCHEMA net TO authenticated;
GRANT USAGE ON SCHEMA net TO service_role;


--
-- TOC entry 4969 (class 0 OID 0)
-- Dependencies: 17
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- TOC entry 4970 (class 0 OID 0)
-- Dependencies: 16
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- TOC entry 4971 (class 0 OID 0)
-- Dependencies: 40
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA storage TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- TOC entry 4972 (class 0 OID 0)
-- Dependencies: 34
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA vault TO service_role;


--
-- TOC entry 4979 (class 0 OID 0)
-- Dependencies: 435
-- Name: FUNCTION gtrgm_in(cstring); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.gtrgm_in(cstring) TO postgres;
GRANT ALL ON FUNCTION public.gtrgm_in(cstring) TO anon;
GRANT ALL ON FUNCTION public.gtrgm_in(cstring) TO authenticated;
GRANT ALL ON FUNCTION public.gtrgm_in(cstring) TO service_role;


--
-- TOC entry 4980 (class 0 OID 0)
-- Dependencies: 495
-- Name: FUNCTION gtrgm_out(public.gtrgm); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.gtrgm_out(public.gtrgm) TO postgres;
GRANT ALL ON FUNCTION public.gtrgm_out(public.gtrgm) TO anon;
GRANT ALL ON FUNCTION public.gtrgm_out(public.gtrgm) TO authenticated;
GRANT ALL ON FUNCTION public.gtrgm_out(public.gtrgm) TO service_role;


--
-- TOC entry 4982 (class 0 OID 0)
-- Dependencies: 576
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- TOC entry 4983 (class 0 OID 0)
-- Dependencies: 561
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- TOC entry 4985 (class 0 OID 0)
-- Dependencies: 575
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- TOC entry 4987 (class 0 OID 0)
-- Dependencies: 580
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- TOC entry 4988 (class 0 OID 0)
-- Dependencies: 455
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- TOC entry 4989 (class 0 OID 0)
-- Dependencies: 419
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea, text[], text[]) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- TOC entry 4990 (class 0 OID 0)
-- Dependencies: 500
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.crypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- TOC entry 4991 (class 0 OID 0)
-- Dependencies: 505
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.dearmor(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- TOC entry 4992 (class 0 OID 0)
-- Dependencies: 423
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4993 (class 0 OID 0)
-- Dependencies: 436
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4994 (class 0 OID 0)
-- Dependencies: 581
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- TOC entry 4995 (class 0 OID 0)
-- Dependencies: 506
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- TOC entry 4996 (class 0 OID 0)
-- Dependencies: 525
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4997 (class 0 OID 0)
-- Dependencies: 578
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4998 (class 0 OID 0)
-- Dependencies: 487
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_bytes(integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- TOC entry 4999 (class 0 OID 0)
-- Dependencies: 562
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_uuid() FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- TOC entry 5000 (class 0 OID 0)
-- Dependencies: 428
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- TOC entry 5001 (class 0 OID 0)
-- Dependencies: 461
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text, integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- TOC entry 5003 (class 0 OID 0)
-- Dependencies: 571
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- TOC entry 5005 (class 0 OID 0)
-- Dependencies: 492
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- TOC entry 5007 (class 0 OID 0)
-- Dependencies: 456
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- TOC entry 5008 (class 0 OID 0)
-- Dependencies: 454
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 5009 (class 0 OID 0)
-- Dependencies: 577
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- TOC entry 5010 (class 0 OID 0)
-- Dependencies: 425
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO dashboard_user;


--
-- TOC entry 5011 (class 0 OID 0)
-- Dependencies: 465
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- TOC entry 5012 (class 0 OID 0)
-- Dependencies: 489
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO dashboard_user;


--
-- TOC entry 5013 (class 0 OID 0)
-- Dependencies: 464
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- TOC entry 5014 (class 0 OID 0)
-- Dependencies: 466
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_key_id(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- TOC entry 5015 (class 0 OID 0)
-- Dependencies: 560
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- TOC entry 5016 (class 0 OID 0)
-- Dependencies: 462
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 5017 (class 0 OID 0)
-- Dependencies: 528
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- TOC entry 5018 (class 0 OID 0)
-- Dependencies: 565
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- TOC entry 5019 (class 0 OID 0)
-- Dependencies: 477
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 5020 (class 0 OID 0)
-- Dependencies: 497
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- TOC entry 5021 (class 0 OID 0)
-- Dependencies: 557
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- TOC entry 5022 (class 0 OID 0)
-- Dependencies: 414
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- TOC entry 5023 (class 0 OID 0)
-- Dependencies: 431
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- TOC entry 5024 (class 0 OID 0)
-- Dependencies: 568
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 5025 (class 0 OID 0)
-- Dependencies: 473
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- TOC entry 5026 (class 0 OID 0)
-- Dependencies: 470
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- TOC entry 5027 (class 0 OID 0)
-- Dependencies: 453
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- TOC entry 5028 (class 0 OID 0)
-- Dependencies: 552
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- TOC entry 5029 (class 0 OID 0)
-- Dependencies: 555
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- TOC entry 5030 (class 0 OID 0)
-- Dependencies: 472
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- TOC entry 5031 (class 0 OID 0)
-- Dependencies: 559
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- TOC entry 5032 (class 0 OID 0)
-- Dependencies: 554
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- TOC entry 5033 (class 0 OID 0)
-- Dependencies: 421
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- TOC entry 5034 (class 0 OID 0)
-- Dependencies: 430
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- TOC entry 5036 (class 0 OID 0)
-- Dependencies: 482
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- TOC entry 5037 (class 0 OID 0)
-- Dependencies: 452
-- Name: FUNCTION unaccent(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.unaccent(text) TO postgres WITH GRANT OPTION;


--
-- TOC entry 5038 (class 0 OID 0)
-- Dependencies: 566
-- Name: FUNCTION unaccent(regdictionary, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.unaccent(regdictionary, text) TO postgres WITH GRANT OPTION;


--
-- TOC entry 5039 (class 0 OID 0)
-- Dependencies: 520
-- Name: FUNCTION unaccent_init(internal); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.unaccent_init(internal) TO postgres WITH GRANT OPTION;


--
-- TOC entry 5040 (class 0 OID 0)
-- Dependencies: 532
-- Name: FUNCTION unaccent_lexize(internal, internal, internal, internal); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.unaccent_lexize(internal, internal, internal, internal) TO postgres WITH GRANT OPTION;


--
-- TOC entry 5041 (class 0 OID 0)
-- Dependencies: 449
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- TOC entry 5042 (class 0 OID 0)
-- Dependencies: 448
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1mc() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- TOC entry 5043 (class 0 OID 0)
-- Dependencies: 516
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- TOC entry 5044 (class 0 OID 0)
-- Dependencies: 545
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v4() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- TOC entry 5045 (class 0 OID 0)
-- Dependencies: 564
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- TOC entry 5046 (class 0 OID 0)
-- Dependencies: 514
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_nil() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- TOC entry 5047 (class 0 OID 0)
-- Dependencies: 474
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_dns() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- TOC entry 5048 (class 0 OID 0)
-- Dependencies: 412
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_oid() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- TOC entry 5049 (class 0 OID 0)
-- Dependencies: 538
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_url() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- TOC entry 5050 (class 0 OID 0)
-- Dependencies: 434
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_x500() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- TOC entry 5051 (class 0 OID 0)
-- Dependencies: 546
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- TOC entry 5052 (class 0 OID 0)
-- Dependencies: 429
-- Name: FUNCTION pg_reload_conf(); Type: ACL; Schema: pg_catalog; Owner: supabase_admin
--

GRANT ALL ON FUNCTION pg_catalog.pg_reload_conf() TO postgres WITH GRANT OPTION;


--
-- TOC entry 5053 (class 0 OID 0)
-- Dependencies: 432
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


--
-- TOC entry 5054 (class 0 OID 0)
-- Dependencies: 443
-- Name: FUNCTION accept_team_invite(p_invite_id uuid, p_profile_id uuid, p_riot_acc_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.accept_team_invite(p_invite_id uuid, p_profile_id uuid, p_riot_acc_id uuid) TO anon;
GRANT ALL ON FUNCTION public.accept_team_invite(p_invite_id uuid, p_profile_id uuid, p_riot_acc_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.accept_team_invite(p_invite_id uuid, p_profile_id uuid, p_riot_acc_id uuid) TO service_role;


--
-- TOC entry 5055 (class 0 OID 0)
-- Dependencies: 573
-- Name: FUNCTION audit_matches_changes(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.audit_matches_changes() TO anon;
GRANT ALL ON FUNCTION public.audit_matches_changes() TO authenticated;
GRANT ALL ON FUNCTION public.audit_matches_changes() TO service_role;


--
-- TOC entry 5056 (class 0 OID 0)
-- Dependencies: 543
-- Name: FUNCTION auto_add_captain_as_member(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.auto_add_captain_as_member() TO anon;
GRANT ALL ON FUNCTION public.auto_add_captain_as_member() TO authenticated;
GRANT ALL ON FUNCTION public.auto_add_captain_as_member() TO service_role;


--
-- TOC entry 5057 (class 0 OID 0)
-- Dependencies: 499
-- Name: FUNCTION call_edge_function(function_name text, payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.call_edge_function(function_name text, payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.call_edge_function(function_name text, payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.call_edge_function(function_name text, payload jsonb) TO service_role;


--
-- TOC entry 5058 (class 0 OID 0)
-- Dependencies: 513
-- Name: FUNCTION ensure_single_primary_riot_account(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ensure_single_primary_riot_account() TO anon;
GRANT ALL ON FUNCTION public.ensure_single_primary_riot_account() TO authenticated;
GRANT ALL ON FUNCTION public.ensure_single_primary_riot_account() TO service_role;


--
-- TOC entry 5059 (class 0 OID 0)
-- Dependencies: 579
-- Name: FUNCTION expire_pending_invites(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.expire_pending_invites() TO anon;
GRANT ALL ON FUNCTION public.expire_pending_invites() TO authenticated;
GRANT ALL ON FUNCTION public.expire_pending_invites() TO service_role;


--
-- TOC entry 5060 (class 0 OID 0)
-- Dependencies: 530
-- Name: FUNCTION fn_notify_inscricao(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_notify_inscricao() TO anon;
GRANT ALL ON FUNCTION public.fn_notify_inscricao() TO authenticated;
GRANT ALL ON FUNCTION public.fn_notify_inscricao() TO service_role;


--
-- TOC entry 5061 (class 0 OID 0)
-- Dependencies: 493
-- Name: FUNCTION generate_tournament_slug(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.generate_tournament_slug() TO anon;
GRANT ALL ON FUNCTION public.generate_tournament_slug() TO authenticated;
GRANT ALL ON FUNCTION public.generate_tournament_slug() TO service_role;


--
-- TOC entry 5062 (class 0 OID 0)
-- Dependencies: 574
-- Name: FUNCTION gin_extract_query_trgm(text, internal, smallint, internal, internal, internal, internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.gin_extract_query_trgm(text, internal, smallint, internal, internal, internal, internal) TO postgres;
GRANT ALL ON FUNCTION public.gin_extract_query_trgm(text, internal, smallint, internal, internal, internal, internal) TO anon;
GRANT ALL ON FUNCTION public.gin_extract_query_trgm(text, internal, smallint, internal, internal, internal, internal) TO authenticated;
GRANT ALL ON FUNCTION public.gin_extract_query_trgm(text, internal, smallint, internal, internal, internal, internal) TO service_role;


--
-- TOC entry 5063 (class 0 OID 0)
-- Dependencies: 547
-- Name: FUNCTION gin_extract_value_trgm(text, internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.gin_extract_value_trgm(text, internal) TO postgres;
GRANT ALL ON FUNCTION public.gin_extract_value_trgm(text, internal) TO anon;
GRANT ALL ON FUNCTION public.gin_extract_value_trgm(text, internal) TO authenticated;
GRANT ALL ON FUNCTION public.gin_extract_value_trgm(text, internal) TO service_role;


--
-- TOC entry 5064 (class 0 OID 0)
-- Dependencies: 469
-- Name: FUNCTION gin_trgm_consistent(internal, smallint, text, integer, internal, internal, internal, internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.gin_trgm_consistent(internal, smallint, text, integer, internal, internal, internal, internal) TO postgres;
GRANT ALL ON FUNCTION public.gin_trgm_consistent(internal, smallint, text, integer, internal, internal, internal, internal) TO anon;
GRANT ALL ON FUNCTION public.gin_trgm_consistent(internal, smallint, text, integer, internal, internal, internal, internal) TO authenticated;
GRANT ALL ON FUNCTION public.gin_trgm_consistent(internal, smallint, text, integer, internal, internal, internal, internal) TO service_role;


--
-- TOC entry 5065 (class 0 OID 0)
-- Dependencies: 539
-- Name: FUNCTION gin_trgm_triconsistent(internal, smallint, text, integer, internal, internal, internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.gin_trgm_triconsistent(internal, smallint, text, integer, internal, internal, internal) TO postgres;
GRANT ALL ON FUNCTION public.gin_trgm_triconsistent(internal, smallint, text, integer, internal, internal, internal) TO anon;
GRANT ALL ON FUNCTION public.gin_trgm_triconsistent(internal, smallint, text, integer, internal, internal, internal) TO authenticated;
GRANT ALL ON FUNCTION public.gin_trgm_triconsistent(internal, smallint, text, integer, internal, internal, internal) TO service_role;


--
-- TOC entry 5066 (class 0 OID 0)
-- Dependencies: 463
-- Name: FUNCTION gtrgm_compress(internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.gtrgm_compress(internal) TO postgres;
GRANT ALL ON FUNCTION public.gtrgm_compress(internal) TO anon;
GRANT ALL ON FUNCTION public.gtrgm_compress(internal) TO authenticated;
GRANT ALL ON FUNCTION public.gtrgm_compress(internal) TO service_role;


--
-- TOC entry 5067 (class 0 OID 0)
-- Dependencies: 551
-- Name: FUNCTION gtrgm_consistent(internal, text, smallint, oid, internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.gtrgm_consistent(internal, text, smallint, oid, internal) TO postgres;
GRANT ALL ON FUNCTION public.gtrgm_consistent(internal, text, smallint, oid, internal) TO anon;
GRANT ALL ON FUNCTION public.gtrgm_consistent(internal, text, smallint, oid, internal) TO authenticated;
GRANT ALL ON FUNCTION public.gtrgm_consistent(internal, text, smallint, oid, internal) TO service_role;


--
-- TOC entry 5068 (class 0 OID 0)
-- Dependencies: 417
-- Name: FUNCTION gtrgm_decompress(internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.gtrgm_decompress(internal) TO postgres;
GRANT ALL ON FUNCTION public.gtrgm_decompress(internal) TO anon;
GRANT ALL ON FUNCTION public.gtrgm_decompress(internal) TO authenticated;
GRANT ALL ON FUNCTION public.gtrgm_decompress(internal) TO service_role;


--
-- TOC entry 5069 (class 0 OID 0)
-- Dependencies: 468
-- Name: FUNCTION gtrgm_distance(internal, text, smallint, oid, internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.gtrgm_distance(internal, text, smallint, oid, internal) TO postgres;
GRANT ALL ON FUNCTION public.gtrgm_distance(internal, text, smallint, oid, internal) TO anon;
GRANT ALL ON FUNCTION public.gtrgm_distance(internal, text, smallint, oid, internal) TO authenticated;
GRANT ALL ON FUNCTION public.gtrgm_distance(internal, text, smallint, oid, internal) TO service_role;


--
-- TOC entry 5070 (class 0 OID 0)
-- Dependencies: 563
-- Name: FUNCTION gtrgm_options(internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.gtrgm_options(internal) TO postgres;
GRANT ALL ON FUNCTION public.gtrgm_options(internal) TO anon;
GRANT ALL ON FUNCTION public.gtrgm_options(internal) TO authenticated;
GRANT ALL ON FUNCTION public.gtrgm_options(internal) TO service_role;


--
-- TOC entry 5071 (class 0 OID 0)
-- Dependencies: 527
-- Name: FUNCTION gtrgm_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.gtrgm_penalty(internal, internal, internal) TO postgres;
GRANT ALL ON FUNCTION public.gtrgm_penalty(internal, internal, internal) TO anon;
GRANT ALL ON FUNCTION public.gtrgm_penalty(internal, internal, internal) TO authenticated;
GRANT ALL ON FUNCTION public.gtrgm_penalty(internal, internal, internal) TO service_role;


--
-- TOC entry 5072 (class 0 OID 0)
-- Dependencies: 537
-- Name: FUNCTION gtrgm_picksplit(internal, internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.gtrgm_picksplit(internal, internal) TO postgres;
GRANT ALL ON FUNCTION public.gtrgm_picksplit(internal, internal) TO anon;
GRANT ALL ON FUNCTION public.gtrgm_picksplit(internal, internal) TO authenticated;
GRANT ALL ON FUNCTION public.gtrgm_picksplit(internal, internal) TO service_role;


--
-- TOC entry 5073 (class 0 OID 0)
-- Dependencies: 503
-- Name: FUNCTION gtrgm_same(public.gtrgm, public.gtrgm, internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.gtrgm_same(public.gtrgm, public.gtrgm, internal) TO postgres;
GRANT ALL ON FUNCTION public.gtrgm_same(public.gtrgm, public.gtrgm, internal) TO anon;
GRANT ALL ON FUNCTION public.gtrgm_same(public.gtrgm, public.gtrgm, internal) TO authenticated;
GRANT ALL ON FUNCTION public.gtrgm_same(public.gtrgm, public.gtrgm, internal) TO service_role;


--
-- TOC entry 5074 (class 0 OID 0)
-- Dependencies: 490
-- Name: FUNCTION gtrgm_union(internal, internal); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.gtrgm_union(internal, internal) TO postgres;
GRANT ALL ON FUNCTION public.gtrgm_union(internal, internal) TO anon;
GRANT ALL ON FUNCTION public.gtrgm_union(internal, internal) TO authenticated;
GRANT ALL ON FUNCTION public.gtrgm_union(internal, internal) TO service_role;


--
-- TOC entry 5075 (class 0 OID 0)
-- Dependencies: 541
-- Name: FUNCTION handle_new_user(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.handle_new_user() TO anon;
GRANT ALL ON FUNCTION public.handle_new_user() TO authenticated;
GRANT ALL ON FUNCTION public.handle_new_user() TO service_role;


--
-- TOC entry 5076 (class 0 OID 0)
-- Dependencies: 488
-- Name: FUNCTION has_call_edge_function(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.has_call_edge_function() TO anon;
GRANT ALL ON FUNCTION public.has_call_edge_function() TO authenticated;
GRANT ALL ON FUNCTION public.has_call_edge_function() TO service_role;


--
-- TOC entry 5077 (class 0 OID 0)
-- Dependencies: 504
-- Name: FUNCTION is_admin(uid uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.is_admin(uid uuid) TO anon;
GRANT ALL ON FUNCTION public.is_admin(uid uuid) TO authenticated;
GRANT ALL ON FUNCTION public.is_admin(uid uuid) TO service_role;


--
-- TOC entry 5078 (class 0 OID 0)
-- Dependencies: 471
-- Name: FUNCTION is_current_user_admin(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.is_current_user_admin() TO anon;
GRANT ALL ON FUNCTION public.is_current_user_admin() TO authenticated;
GRANT ALL ON FUNCTION public.is_current_user_admin() TO service_role;


--
-- TOC entry 5079 (class 0 OID 0)
-- Dependencies: 458
-- Name: FUNCTION is_organizer_or_admin(uid uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.is_organizer_or_admin(uid uuid) TO anon;
GRANT ALL ON FUNCTION public.is_organizer_or_admin(uid uuid) TO authenticated;
GRANT ALL ON FUNCTION public.is_organizer_or_admin(uid uuid) TO service_role;


--
-- TOC entry 5080 (class 0 OID 0)
-- Dependencies: 410
-- Name: FUNCTION is_tournament_organizer(uid uuid, tid uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.is_tournament_organizer(uid uuid, tid uuid) TO anon;
GRANT ALL ON FUNCTION public.is_tournament_organizer(uid uuid, tid uuid) TO authenticated;
GRANT ALL ON FUNCTION public.is_tournament_organizer(uid uuid, tid uuid) TO service_role;


--
-- TOC entry 5081 (class 0 OID 0)
-- Dependencies: 582
-- Name: FUNCTION log_admin_action(p_action text, p_table_name text, p_record_id text, p_old_data jsonb, p_new_data jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.log_admin_action(p_action text, p_table_name text, p_record_id text, p_old_data jsonb, p_new_data jsonb) TO anon;
GRANT ALL ON FUNCTION public.log_admin_action(p_action text, p_table_name text, p_record_id text, p_old_data jsonb, p_new_data jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.log_admin_action(p_action text, p_table_name text, p_record_id text, p_old_data jsonb, p_new_data jsonb) TO service_role;


--
-- TOC entry 5082 (class 0 OID 0)
-- Dependencies: 570
-- Name: FUNCTION set_limit(real); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.set_limit(real) TO postgres;
GRANT ALL ON FUNCTION public.set_limit(real) TO anon;
GRANT ALL ON FUNCTION public.set_limit(real) TO authenticated;
GRANT ALL ON FUNCTION public.set_limit(real) TO service_role;


--
-- TOC entry 5083 (class 0 OID 0)
-- Dependencies: 444
-- Name: FUNCTION set_updated_at(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.set_updated_at() TO anon;
GRANT ALL ON FUNCTION public.set_updated_at() TO authenticated;
GRANT ALL ON FUNCTION public.set_updated_at() TO service_role;


--
-- TOC entry 5084 (class 0 OID 0)
-- Dependencies: 567
-- Name: FUNCTION show_limit(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.show_limit() TO postgres;
GRANT ALL ON FUNCTION public.show_limit() TO anon;
GRANT ALL ON FUNCTION public.show_limit() TO authenticated;
GRANT ALL ON FUNCTION public.show_limit() TO service_role;


--
-- TOC entry 5085 (class 0 OID 0)
-- Dependencies: 512
-- Name: FUNCTION show_trgm(text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.show_trgm(text) TO postgres;
GRANT ALL ON FUNCTION public.show_trgm(text) TO anon;
GRANT ALL ON FUNCTION public.show_trgm(text) TO authenticated;
GRANT ALL ON FUNCTION public.show_trgm(text) TO service_role;


--
-- TOC entry 5086 (class 0 OID 0)
-- Dependencies: 508
-- Name: FUNCTION similarity(text, text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.similarity(text, text) TO postgres;
GRANT ALL ON FUNCTION public.similarity(text, text) TO anon;
GRANT ALL ON FUNCTION public.similarity(text, text) TO authenticated;
GRANT ALL ON FUNCTION public.similarity(text, text) TO service_role;


--
-- TOC entry 5087 (class 0 OID 0)
-- Dependencies: 481
-- Name: FUNCTION similarity_dist(text, text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.similarity_dist(text, text) TO postgres;
GRANT ALL ON FUNCTION public.similarity_dist(text, text) TO anon;
GRANT ALL ON FUNCTION public.similarity_dist(text, text) TO authenticated;
GRANT ALL ON FUNCTION public.similarity_dist(text, text) TO service_role;


--
-- TOC entry 5088 (class 0 OID 0)
-- Dependencies: 445
-- Name: FUNCTION similarity_op(text, text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.similarity_op(text, text) TO postgres;
GRANT ALL ON FUNCTION public.similarity_op(text, text) TO anon;
GRANT ALL ON FUNCTION public.similarity_op(text, text) TO authenticated;
GRANT ALL ON FUNCTION public.similarity_op(text, text) TO service_role;


--
-- TOC entry 5089 (class 0 OID 0)
-- Dependencies: 484
-- Name: FUNCTION strict_word_similarity(text, text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.strict_word_similarity(text, text) TO postgres;
GRANT ALL ON FUNCTION public.strict_word_similarity(text, text) TO anon;
GRANT ALL ON FUNCTION public.strict_word_similarity(text, text) TO authenticated;
GRANT ALL ON FUNCTION public.strict_word_similarity(text, text) TO service_role;


--
-- TOC entry 5090 (class 0 OID 0)
-- Dependencies: 515
-- Name: FUNCTION strict_word_similarity_commutator_op(text, text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.strict_word_similarity_commutator_op(text, text) TO postgres;
GRANT ALL ON FUNCTION public.strict_word_similarity_commutator_op(text, text) TO anon;
GRANT ALL ON FUNCTION public.strict_word_similarity_commutator_op(text, text) TO authenticated;
GRANT ALL ON FUNCTION public.strict_word_similarity_commutator_op(text, text) TO service_role;


--
-- TOC entry 5091 (class 0 OID 0)
-- Dependencies: 418
-- Name: FUNCTION strict_word_similarity_dist_commutator_op(text, text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.strict_word_similarity_dist_commutator_op(text, text) TO postgres;
GRANT ALL ON FUNCTION public.strict_word_similarity_dist_commutator_op(text, text) TO anon;
GRANT ALL ON FUNCTION public.strict_word_similarity_dist_commutator_op(text, text) TO authenticated;
GRANT ALL ON FUNCTION public.strict_word_similarity_dist_commutator_op(text, text) TO service_role;


--
-- TOC entry 5092 (class 0 OID 0)
-- Dependencies: 457
-- Name: FUNCTION strict_word_similarity_dist_op(text, text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.strict_word_similarity_dist_op(text, text) TO postgres;
GRANT ALL ON FUNCTION public.strict_word_similarity_dist_op(text, text) TO anon;
GRANT ALL ON FUNCTION public.strict_word_similarity_dist_op(text, text) TO authenticated;
GRANT ALL ON FUNCTION public.strict_word_similarity_dist_op(text, text) TO service_role;


--
-- TOC entry 5093 (class 0 OID 0)
-- Dependencies: 459
-- Name: FUNCTION strict_word_similarity_op(text, text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.strict_word_similarity_op(text, text) TO postgres;
GRANT ALL ON FUNCTION public.strict_word_similarity_op(text, text) TO anon;
GRANT ALL ON FUNCTION public.strict_word_similarity_op(text, text) TO authenticated;
GRANT ALL ON FUNCTION public.strict_word_similarity_op(text, text) TO service_role;


--
-- TOC entry 5094 (class 0 OID 0)
-- Dependencies: 483
-- Name: FUNCTION sync_notifications_body_message(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.sync_notifications_body_message() TO anon;
GRANT ALL ON FUNCTION public.sync_notifications_body_message() TO authenticated;
GRANT ALL ON FUNCTION public.sync_notifications_body_message() TO service_role;


--
-- TOC entry 5095 (class 0 OID 0)
-- Dependencies: 509
-- Name: FUNCTION trg_inscricao_nova(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.trg_inscricao_nova() TO anon;
GRANT ALL ON FUNCTION public.trg_inscricao_nova() TO authenticated;
GRANT ALL ON FUNCTION public.trg_inscricao_nova() TO service_role;


--
-- TOC entry 5096 (class 0 OID 0)
-- Dependencies: 569
-- Name: FUNCTION trg_inscricao_status_change(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.trg_inscricao_status_change() TO anon;
GRANT ALL ON FUNCTION public.trg_inscricao_status_change() TO authenticated;
GRANT ALL ON FUNCTION public.trg_inscricao_status_change() TO service_role;


--
-- TOC entry 5097 (class 0 OID 0)
-- Dependencies: 420
-- Name: FUNCTION trg_match_finished(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.trg_match_finished() TO anon;
GRANT ALL ON FUNCTION public.trg_match_finished() TO authenticated;
GRANT ALL ON FUNCTION public.trg_match_finished() TO service_role;


--
-- TOC entry 5098 (class 0 OID 0)
-- Dependencies: 447
-- Name: FUNCTION trg_tournament_started(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.trg_tournament_started() TO anon;
GRANT ALL ON FUNCTION public.trg_tournament_started() TO authenticated;
GRANT ALL ON FUNCTION public.trg_tournament_started() TO service_role;


--
-- TOC entry 5099 (class 0 OID 0)
-- Dependencies: 438
-- Name: FUNCTION word_similarity(text, text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.word_similarity(text, text) TO postgres;
GRANT ALL ON FUNCTION public.word_similarity(text, text) TO anon;
GRANT ALL ON FUNCTION public.word_similarity(text, text) TO authenticated;
GRANT ALL ON FUNCTION public.word_similarity(text, text) TO service_role;


--
-- TOC entry 5100 (class 0 OID 0)
-- Dependencies: 496
-- Name: FUNCTION word_similarity_commutator_op(text, text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.word_similarity_commutator_op(text, text) TO postgres;
GRANT ALL ON FUNCTION public.word_similarity_commutator_op(text, text) TO anon;
GRANT ALL ON FUNCTION public.word_similarity_commutator_op(text, text) TO authenticated;
GRANT ALL ON FUNCTION public.word_similarity_commutator_op(text, text) TO service_role;


--
-- TOC entry 5101 (class 0 OID 0)
-- Dependencies: 491
-- Name: FUNCTION word_similarity_dist_commutator_op(text, text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.word_similarity_dist_commutator_op(text, text) TO postgres;
GRANT ALL ON FUNCTION public.word_similarity_dist_commutator_op(text, text) TO anon;
GRANT ALL ON FUNCTION public.word_similarity_dist_commutator_op(text, text) TO authenticated;
GRANT ALL ON FUNCTION public.word_similarity_dist_commutator_op(text, text) TO service_role;


--
-- TOC entry 5102 (class 0 OID 0)
-- Dependencies: 535
-- Name: FUNCTION word_similarity_dist_op(text, text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.word_similarity_dist_op(text, text) TO postgres;
GRANT ALL ON FUNCTION public.word_similarity_dist_op(text, text) TO anon;
GRANT ALL ON FUNCTION public.word_similarity_dist_op(text, text) TO authenticated;
GRANT ALL ON FUNCTION public.word_similarity_dist_op(text, text) TO service_role;


--
-- TOC entry 5103 (class 0 OID 0)
-- Dependencies: 556
-- Name: FUNCTION word_similarity_op(text, text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.word_similarity_op(text, text) TO postgres;
GRANT ALL ON FUNCTION public.word_similarity_op(text, text) TO anon;
GRANT ALL ON FUNCTION public.word_similarity_op(text, text) TO authenticated;
GRANT ALL ON FUNCTION public.word_similarity_op(text, text) TO service_role;


--
-- TOC entry 5104 (class 0 OID 0)
-- Dependencies: 549
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO supabase_realtime_admin;


--
-- TOC entry 5105 (class 0 OID 0)
-- Dependencies: 416
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- TOC entry 5106 (class 0 OID 0)
-- Dependencies: 544
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO supabase_realtime_admin;


--
-- TOC entry 5107 (class 0 OID 0)
-- Dependencies: 480
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO supabase_realtime_admin;


--
-- TOC entry 5108 (class 0 OID 0)
-- Dependencies: 413
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO supabase_realtime_admin;


--
-- TOC entry 5109 (class 0 OID 0)
-- Dependencies: 510
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO supabase_realtime_admin;


--
-- TOC entry 5110 (class 0 OID 0)
-- Dependencies: 479
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;


--
-- TOC entry 5111 (class 0 OID 0)
-- Dependencies: 478
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO supabase_realtime_admin;


--
-- TOC entry 5112 (class 0 OID 0)
-- Dependencies: 408
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- TOC entry 5113 (class 0 OID 0)
-- Dependencies: 442
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO supabase_realtime_admin;


--
-- TOC entry 5114 (class 0 OID 0)
-- Dependencies: 526
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO supabase_realtime_admin;


--
-- TOC entry 5115 (class 0 OID 0)
-- Dependencies: 540
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- TOC entry 5116 (class 0 OID 0)
-- Dependencies: 533
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO service_role;


--
-- TOC entry 5117 (class 0 OID 0)
-- Dependencies: 529
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- TOC entry 5118 (class 0 OID 0)
-- Dependencies: 548
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- TOC entry 5120 (class 0 OID 0)
-- Dependencies: 332
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- TOC entry 5121 (class 0 OID 0)
-- Dependencies: 351
-- Name: TABLE custom_oauth_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.custom_oauth_providers TO postgres;
GRANT ALL ON TABLE auth.custom_oauth_providers TO dashboard_user;


--
-- TOC entry 5123 (class 0 OID 0)
-- Dependencies: 345
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- TOC entry 5126 (class 0 OID 0)
-- Dependencies: 336
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- TOC entry 5128 (class 0 OID 0)
-- Dependencies: 331
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- TOC entry 5130 (class 0 OID 0)
-- Dependencies: 340
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- TOC entry 5132 (class 0 OID 0)
-- Dependencies: 339
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- TOC entry 5135 (class 0 OID 0)
-- Dependencies: 338
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- TOC entry 5136 (class 0 OID 0)
-- Dependencies: 348
-- Name: TABLE oauth_authorizations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_authorizations TO postgres;
GRANT ALL ON TABLE auth.oauth_authorizations TO dashboard_user;


--
-- TOC entry 5138 (class 0 OID 0)
-- Dependencies: 350
-- Name: TABLE oauth_client_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_client_states TO postgres;
GRANT ALL ON TABLE auth.oauth_client_states TO dashboard_user;


--
-- TOC entry 5139 (class 0 OID 0)
-- Dependencies: 347
-- Name: TABLE oauth_clients; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_clients TO postgres;
GRANT ALL ON TABLE auth.oauth_clients TO dashboard_user;


--
-- TOC entry 5140 (class 0 OID 0)
-- Dependencies: 349
-- Name: TABLE oauth_consents; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_consents TO postgres;
GRANT ALL ON TABLE auth.oauth_consents TO dashboard_user;


--
-- TOC entry 5141 (class 0 OID 0)
-- Dependencies: 346
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- TOC entry 5143 (class 0 OID 0)
-- Dependencies: 330
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- TOC entry 5145 (class 0 OID 0)
-- Dependencies: 329
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- TOC entry 5147 (class 0 OID 0)
-- Dependencies: 343
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- TOC entry 5149 (class 0 OID 0)
-- Dependencies: 344
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- TOC entry 5151 (class 0 OID 0)
-- Dependencies: 333
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


--
-- TOC entry 5156 (class 0 OID 0)
-- Dependencies: 337
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- TOC entry 5158 (class 0 OID 0)
-- Dependencies: 342
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- TOC entry 5161 (class 0 OID 0)
-- Dependencies: 341
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- TOC entry 5164 (class 0 OID 0)
-- Dependencies: 328
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- TOC entry 5165 (class 0 OID 0)
-- Dependencies: 353
-- Name: TABLE webauthn_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_challenges TO postgres;
GRANT ALL ON TABLE auth.webauthn_challenges TO dashboard_user;


--
-- TOC entry 5166 (class 0 OID 0)
-- Dependencies: 352
-- Name: TABLE webauthn_credentials; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_credentials TO postgres;
GRANT ALL ON TABLE auth.webauthn_credentials TO dashboard_user;


--
-- TOC entry 5167 (class 0 OID 0)
-- Dependencies: 327
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- TOC entry 5168 (class 0 OID 0)
-- Dependencies: 326
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements_info FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- TOC entry 5169 (class 0 OID 0)
-- Dependencies: 405
-- Name: TABLE active_team; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.active_team TO anon;
GRANT ALL ON TABLE public.active_team TO authenticated;
GRANT ALL ON TABLE public.active_team TO service_role;


--
-- TOC entry 5170 (class 0 OID 0)
-- Dependencies: 384
-- Name: TABLE audit_log; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.audit_log TO anon;
GRANT ALL ON TABLE public.audit_log TO authenticated;
GRANT ALL ON TABLE public.audit_log TO service_role;


--
-- TOC entry 5171 (class 0 OID 0)
-- Dependencies: 396
-- Name: TABLE champion_masteries; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.champion_masteries TO anon;
GRANT ALL ON TABLE public.champion_masteries TO authenticated;
GRANT ALL ON TABLE public.champion_masteries TO service_role;


--
-- TOC entry 5172 (class 0 OID 0)
-- Dependencies: 382
-- Name: TABLE disputes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.disputes TO anon;
GRANT ALL ON TABLE public.disputes TO authenticated;
GRANT ALL ON TABLE public.disputes TO service_role;


--
-- TOC entry 5176 (class 0 OID 0)
-- Dependencies: 373
-- Name: TABLE inscricoes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.inscricoes TO anon;
GRANT ALL ON TABLE public.inscricoes TO authenticated;
GRANT ALL ON TABLE public.inscricoes TO service_role;


--
-- TOC entry 5177 (class 0 OID 0)
-- Dependencies: 376
-- Name: TABLE match_games; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.match_games TO anon;
GRANT ALL ON TABLE public.match_games TO authenticated;
GRANT ALL ON TABLE public.match_games TO service_role;


--
-- TOC entry 5178 (class 0 OID 0)
-- Dependencies: 374
-- Name: TABLE matches; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.matches TO anon;
GRANT ALL ON TABLE public.matches TO authenticated;
GRANT ALL ON TABLE public.matches TO service_role;


--
-- TOC entry 5179 (class 0 OID 0)
-- Dependencies: 378
-- Name: TABLE notifications; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.notifications TO anon;
GRANT ALL ON TABLE public.notifications TO authenticated;
GRANT ALL ON TABLE public.notifications TO service_role;


--
-- TOC entry 5180 (class 0 OID 0)
-- Dependencies: 377
-- Name: TABLE player_stats; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.player_stats TO anon;
GRANT ALL ON TABLE public.player_stats TO authenticated;
GRANT ALL ON TABLE public.player_stats TO service_role;


--
-- TOC entry 5181 (class 0 OID 0)
-- Dependencies: 372
-- Name: TABLE players; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.players TO anon;
GRANT ALL ON TABLE public.players TO authenticated;
GRANT ALL ON TABLE public.players TO service_role;


--
-- TOC entry 5182 (class 0 OID 0)
-- Dependencies: 379
-- Name: TABLE prize_distribution; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.prize_distribution TO anon;
GRANT ALL ON TABLE public.prize_distribution TO authenticated;
GRANT ALL ON TABLE public.prize_distribution TO service_role;


--
-- TOC entry 5183 (class 0 OID 0)
-- Dependencies: 369
-- Name: TABLE profiles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.profiles TO anon;
GRANT ALL ON TABLE public.profiles TO authenticated;
GRANT ALL ON TABLE public.profiles TO service_role;


--
-- TOC entry 5184 (class 0 OID 0)
-- Dependencies: 395
-- Name: TABLE rank_snapshots; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.rank_snapshots TO anon;
GRANT ALL ON TABLE public.rank_snapshots TO authenticated;
GRANT ALL ON TABLE public.rank_snapshots TO service_role;


--
-- TOC entry 5185 (class 0 OID 0)
-- Dependencies: 394
-- Name: TABLE riot_accounts; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.riot_accounts TO anon;
GRANT ALL ON TABLE public.riot_accounts TO authenticated;
GRANT ALL ON TABLE public.riot_accounts TO service_role;


--
-- TOC entry 5186 (class 0 OID 0)
-- Dependencies: 380
-- Name: TABLE seedings; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.seedings TO anon;
GRANT ALL ON TABLE public.seedings TO authenticated;
GRANT ALL ON TABLE public.seedings TO service_role;


--
-- TOC entry 5188 (class 0 OID 0)
-- Dependencies: 402
-- Name: TABLE site_terms_acceptance; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.site_terms_acceptance TO anon;
GRANT ALL ON TABLE public.site_terms_acceptance TO authenticated;
GRANT ALL ON TABLE public.site_terms_acceptance TO service_role;


--
-- TOC entry 5189 (class 0 OID 0)
-- Dependencies: 381
-- Name: TABLE team_invites; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.team_invites TO anon;
GRANT ALL ON TABLE public.team_invites TO authenticated;
GRANT ALL ON TABLE public.team_invites TO service_role;


--
-- TOC entry 5190 (class 0 OID 0)
-- Dependencies: 404
-- Name: TABLE team_members; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.team_members TO anon;
GRANT ALL ON TABLE public.team_members TO authenticated;
GRANT ALL ON TABLE public.team_members TO service_role;


--
-- TOC entry 5191 (class 0 OID 0)
-- Dependencies: 371
-- Name: TABLE teams; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.teams TO anon;
GRANT ALL ON TABLE public.teams TO authenticated;
GRANT ALL ON TABLE public.teams TO service_role;


--
-- TOC entry 5192 (class 0 OID 0)
-- Dependencies: 406
-- Name: TABLE tournament_match_results; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tournament_match_results TO anon;
GRANT ALL ON TABLE public.tournament_match_results TO authenticated;
GRANT ALL ON TABLE public.tournament_match_results TO service_role;


--
-- TOC entry 5193 (class 0 OID 0)
-- Dependencies: 383
-- Name: TABLE tournament_rules; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tournament_rules TO anon;
GRANT ALL ON TABLE public.tournament_rules TO authenticated;
GRANT ALL ON TABLE public.tournament_rules TO service_role;


--
-- TOC entry 5194 (class 0 OID 0)
-- Dependencies: 375
-- Name: TABLE tournament_stages; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tournament_stages TO anon;
GRANT ALL ON TABLE public.tournament_stages TO authenticated;
GRANT ALL ON TABLE public.tournament_stages TO service_role;


--
-- TOC entry 5197 (class 0 OID 0)
-- Dependencies: 370
-- Name: TABLE tournaments; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tournaments TO anon;
GRANT ALL ON TABLE public.tournaments TO authenticated;
GRANT ALL ON TABLE public.tournaments TO service_role;


--
-- TOC entry 5198 (class 0 OID 0)
-- Dependencies: 388
-- Name: TABLE v_player_leaderboard; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_player_leaderboard TO anon;
GRANT ALL ON TABLE public.v_player_leaderboard TO authenticated;
GRANT ALL ON TABLE public.v_player_leaderboard TO service_role;


--
-- TOC entry 5199 (class 0 OID 0)
-- Dependencies: 386
-- Name: TABLE v_player_tournament_kda; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_player_tournament_kda TO anon;
GRANT ALL ON TABLE public.v_player_tournament_kda TO authenticated;
GRANT ALL ON TABLE public.v_player_tournament_kda TO service_role;


--
-- TOC entry 5200 (class 0 OID 0)
-- Dependencies: 387
-- Name: TABLE v_stage_standings; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_stage_standings TO anon;
GRANT ALL ON TABLE public.v_stage_standings TO authenticated;
GRANT ALL ON TABLE public.v_stage_standings TO service_role;


--
-- TOC entry 5201 (class 0 OID 0)
-- Dependencies: 368
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- TOC entry 5202 (class 0 OID 0)
-- Dependencies: 397
-- Name: TABLE messages_2026_04_24; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_04_24 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_04_24 TO dashboard_user;


--
-- TOC entry 5203 (class 0 OID 0)
-- Dependencies: 398
-- Name: TABLE messages_2026_04_25; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_04_25 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_04_25 TO dashboard_user;


--
-- TOC entry 5204 (class 0 OID 0)
-- Dependencies: 399
-- Name: TABLE messages_2026_04_26; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_04_26 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_04_26 TO dashboard_user;


--
-- TOC entry 5205 (class 0 OID 0)
-- Dependencies: 400
-- Name: TABLE messages_2026_04_27; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_04_27 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_04_27 TO dashboard_user;


--
-- TOC entry 5206 (class 0 OID 0)
-- Dependencies: 401
-- Name: TABLE messages_2026_04_28; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_04_28 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_04_28 TO dashboard_user;


--
-- TOC entry 5207 (class 0 OID 0)
-- Dependencies: 403
-- Name: TABLE messages_2026_04_29; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_04_29 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_04_29 TO dashboard_user;


--
-- TOC entry 5208 (class 0 OID 0)
-- Dependencies: 407
-- Name: TABLE messages_2026_04_30; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_04_30 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_04_30 TO dashboard_user;


--
-- TOC entry 5209 (class 0 OID 0)
-- Dependencies: 362
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;
GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;
GRANT SELECT ON TABLE realtime.schema_migrations TO anon;
GRANT SELECT ON TABLE realtime.schema_migrations TO authenticated;
GRANT SELECT ON TABLE realtime.schema_migrations TO service_role;
GRANT ALL ON TABLE realtime.schema_migrations TO supabase_realtime_admin;


--
-- TOC entry 5210 (class 0 OID 0)
-- Dependencies: 365
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;
GRANT ALL ON TABLE realtime.subscription TO supabase_realtime_admin;


--
-- TOC entry 5211 (class 0 OID 0)
-- Dependencies: 364
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO supabase_realtime_admin;


--
-- TOC entry 5213 (class 0 OID 0)
-- Dependencies: 355
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.buckets FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.buckets TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO postgres WITH GRANT OPTION;


--
-- TOC entry 5214 (class 0 OID 0)
-- Dependencies: 359
-- Name: TABLE buckets_analytics; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets_analytics TO service_role;
GRANT ALL ON TABLE storage.buckets_analytics TO authenticated;
GRANT ALL ON TABLE storage.buckets_analytics TO anon;


--
-- TOC entry 5215 (class 0 OID 0)
-- Dependencies: 360
-- Name: TABLE buckets_vectors; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.buckets_vectors TO service_role;
GRANT SELECT ON TABLE storage.buckets_vectors TO authenticated;
GRANT SELECT ON TABLE storage.buckets_vectors TO anon;


--
-- TOC entry 5217 (class 0 OID 0)
-- Dependencies: 356
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.objects FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.objects TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO postgres WITH GRANT OPTION;


--
-- TOC entry 5218 (class 0 OID 0)
-- Dependencies: 357
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;


--
-- TOC entry 5219 (class 0 OID 0)
-- Dependencies: 358
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;


--
-- TOC entry 5220 (class 0 OID 0)
-- Dependencies: 361
-- Name: TABLE vector_indexes; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.vector_indexes TO service_role;
GRANT SELECT ON TABLE storage.vector_indexes TO authenticated;
GRANT SELECT ON TABLE storage.vector_indexes TO anon;


--
-- TOC entry 5221 (class 0 OID 0)
-- Dependencies: 334
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.secrets TO service_role;


--
-- TOC entry 5222 (class 0 OID 0)
-- Dependencies: 335
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO service_role;


--
-- TOC entry 2721 (class 826 OID 16557)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- TOC entry 2722 (class 826 OID 16558)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- TOC entry 2720 (class 826 OID 16556)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO dashboard_user;


--
-- TOC entry 2731 (class 826 OID 16636)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- TOC entry 2730 (class 826 OID 16635)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- TOC entry 2729 (class 826 OID 16634)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;


--
-- TOC entry 2734 (class 826 OID 16591)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;


--
-- TOC entry 2733 (class 826 OID 16590)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;


--
-- TOC entry 2732 (class 826 OID 16589)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO service_role;


--
-- TOC entry 2726 (class 826 OID 16571)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;


--
-- TOC entry 2728 (class 826 OID 16570)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;


--
-- TOC entry 2727 (class 826 OID 16569)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO service_role;


--
-- TOC entry 2713 (class 826 OID 16494)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- TOC entry 2714 (class 826 OID 16495)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- TOC entry 2712 (class 826 OID 16493)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- TOC entry 2716 (class 826 OID 16497)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- TOC entry 2711 (class 826 OID 16492)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- TOC entry 2715 (class 826 OID 16496)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- TOC entry 2724 (class 826 OID 16561)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- TOC entry 2725 (class 826 OID 16562)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- TOC entry 2723 (class 826 OID 16560)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO dashboard_user;


--
-- TOC entry 2719 (class 826 OID 16550)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- TOC entry 2718 (class 826 OID 16549)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- TOC entry 2717 (class 826 OID 16548)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;


--
-- TOC entry 3948 (class 3466 OID 16575)
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- TOC entry 3951 (class 3466 OID 16654)
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- TOC entry 3947 (class 3466 OID 16573)
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- TOC entry 3952 (class 3466 OID 16657)
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- TOC entry 3949 (class 3466 OID 16576)
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- TOC entry 3950 (class 3466 OID 16577)
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

-- Completed on 2026-04-26 21:49:52

--
-- PostgreSQL database dump complete
--

\unrestrict q2NHpilvUIYschoZHPktvxDpcbG10hukebo8OtLF6jQ3wxlVsTkqwrQTydBVT8z

