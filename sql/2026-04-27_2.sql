
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
-- TOC entry 387 (class 1259 OID 18257)
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
-- TOC entry 3956 (class 0 OID 0)
-- Name: messages_2026_04_24; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_04_24 FOR VALUES FROM ('2026-04-24 00:00:00') TO ('2026-04-25 00:00:00');


--
-- TOC entry 3957 (class 0 OID 0)
-- Name: messages_2026_04_25; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_04_25 FOR VALUES FROM ('2026-04-25 00:00:00') TO ('2026-04-26 00:00:00');


--
-- TOC entry 3958 (class 0 OID 0)
-- Name: messages_2026_04_26; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_04_26 FOR VALUES FROM ('2026-04-26 00:00:00') TO ('2026-04-27 00:00:00');


--
-- TOC entry 3959 (class 0 OID 0)
-- Name: messages_2026_04_27; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_04_27 FOR VALUES FROM ('2026-04-27 00:00:00') TO ('2026-04-28 00:00:00');


--
-- TOC entry 3960 (class 0 OID 0)
-- Name: messages_2026_04_28; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_04_28 FOR VALUES FROM ('2026-04-28 00:00:00') TO ('2026-04-29 00:00:00');


--
-- TOC entry 3961 (class 0 OID 0)
-- Name: messages_2026_04_29; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_04_29 FOR VALUES FROM ('2026-04-29 00:00:00') TO ('2026-04-30 00:00:00');


--
-- TOC entry 3962 (class 0 OID 0)
-- Name: messages_2026_04_30; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_04_30 FOR VALUES FROM ('2026-04-30 00:00:00') TO ('2026-05-01 00:00:00');


--
-- TOC entry 3972 (class 2604 OID 16514)
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- TOC entry 4311 (class 2606 OID 16787)
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- TOC entry 4280 (class 2606 OID 16535)
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- TOC entry 4366 (class 2606 OID 17119)
-- Name: custom_oauth_providers custom_oauth_providers_identifier_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_identifier_key UNIQUE (identifier);


--
-- TOC entry 4368 (class 2606 OID 17117)
-- Name: custom_oauth_providers custom_oauth_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 4334 (class 2606 OID 16893)
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- TOC entry 4289 (class 2606 OID 16911)
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- TOC entry 4291 (class 2606 OID 16921)
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- TOC entry 4278 (class 2606 OID 16528)
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- TOC entry 4313 (class 2606 OID 16780)
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- TOC entry 4309 (class 2606 OID 16768)
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- TOC entry 4301 (class 2606 OID 16961)
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- TOC entry 4303 (class 2606 OID 16755)
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- TOC entry 4347 (class 2606 OID 17020)
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- TOC entry 4349 (class 2606 OID 17018)
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- TOC entry 4351 (class 2606 OID 17016)
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- TOC entry 4361 (class 2606 OID 17078)
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- TOC entry 4344 (class 2606 OID 16980)
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- TOC entry 4355 (class 2606 OID 17042)
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- TOC entry 4357 (class 2606 OID 17044)
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- TOC entry 4338 (class 2606 OID 16946)
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4272 (class 2606 OID 16518)
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4275 (class 2606 OID 16697)
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- TOC entry 4323 (class 2606 OID 16827)
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- TOC entry 4325 (class 2606 OID 16825)
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 4330 (class 2606 OID 16841)
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- TOC entry 4283 (class 2606 OID 16541)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4296 (class 2606 OID 16718)
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 4320 (class 2606 OID 16808)
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- TOC entry 4315 (class 2606 OID 16799)
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 4265 (class 2606 OID 16881)
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- TOC entry 4267 (class 2606 OID 16505)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4376 (class 2606 OID 17156)
-- Name: webauthn_challenges webauthn_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_pkey PRIMARY KEY (id);


--
-- TOC entry 4372 (class 2606 OID 17139)
-- Name: webauthn_credentials webauthn_credentials_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_pkey PRIMARY KEY (id);


--
-- TOC entry 4558 (class 2606 OID 19870)
-- Name: active_team active_team_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_team
    ADD CONSTRAINT active_team_pkey PRIMARY KEY (profile_id);


--
-- TOC entry 4505 (class 2606 OID 18241)
-- Name: audit_log audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_pkey PRIMARY KEY (id);


--
-- TOC entry 4523 (class 2606 OID 18495)
-- Name: champion_masteries champion_masteries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.champion_masteries
    ADD CONSTRAINT champion_masteries_pkey PRIMARY KEY (id);


--
-- TOC entry 4525 (class 2606 OID 18497)
-- Name: champion_masteries champion_masteries_unique_account_champion; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.champion_masteries
    ADD CONSTRAINT champion_masteries_unique_account_champion UNIQUE (riot_account_id, champion_id);


--
-- TOC entry 4501 (class 2606 OID 18199)
-- Name: disputes disputes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disputes
    ADD CONSTRAINT disputes_pkey PRIMARY KEY (id);


--
-- TOC entry 4447 (class 2606 OID 17778)
-- Name: inscricoes inscricoes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inscricoes
    ADD CONSTRAINT inscricoes_pkey PRIMARY KEY (id);


--
-- TOC entry 4449 (class 2606 OID 17780)
-- Name: inscricoes inscricoes_tournament_id_team_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inscricoes
    ADD CONSTRAINT inscricoes_tournament_id_team_id_key UNIQUE (tournament_id, team_id);


--
-- TOC entry 4465 (class 2606 OID 17907)
-- Name: match_games match_games_match_id_game_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_games
    ADD CONSTRAINT match_games_match_id_game_number_key UNIQUE (match_id, game_number);


--
-- TOC entry 4467 (class 2606 OID 17905)
-- Name: match_games match_games_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_games
    ADD CONSTRAINT match_games_pkey PRIMARY KEY (id);


--
-- TOC entry 4459 (class 2606 OID 17816)
-- Name: matches matches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_pkey PRIMARY KEY (id);


--
-- TOC entry 4483 (class 2606 OID 17986)
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 4475 (class 2606 OID 17940)
-- Name: player_stats player_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.player_stats
    ADD CONSTRAINT player_stats_pkey PRIMARY KEY (id);


--
-- TOC entry 4437 (class 2606 OID 17758)
-- Name: players players_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_pkey PRIMARY KEY (id);


--
-- TOC entry 4439 (class 2606 OID 17760)
-- Name: players players_puuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_puuid_key UNIQUE (puuid);


--
-- TOC entry 4486 (class 2606 OID 18115)
-- Name: prize_distribution prize_distribution_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prize_distribution
    ADD CONSTRAINT prize_distribution_pkey PRIMARY KEY (id);


--
-- TOC entry 4414 (class 2606 OID 17691)
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- TOC entry 4521 (class 2606 OID 18476)
-- Name: rank_snapshots rank_snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rank_snapshots
    ADD CONSTRAINT rank_snapshots_pkey PRIMARY KEY (id);


--
-- TOC entry 4517 (class 2606 OID 18452)
-- Name: riot_accounts riot_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.riot_accounts
    ADD CONSTRAINT riot_accounts_pkey PRIMARY KEY (id);


--
-- TOC entry 4490 (class 2606 OID 18132)
-- Name: seedings seedings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seedings
    ADD CONSTRAINT seedings_pkey PRIMARY KEY (id);


--
-- TOC entry 4492 (class 2606 OID 18136)
-- Name: seedings seedings_tournament_id_seed_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seedings
    ADD CONSTRAINT seedings_tournament_id_seed_key UNIQUE (tournament_id, seed);


--
-- TOC entry 4494 (class 2606 OID 18134)
-- Name: seedings seedings_tournament_id_team_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seedings
    ADD CONSTRAINT seedings_tournament_id_team_id_key UNIQUE (tournament_id, team_id);


--
-- TOC entry 4544 (class 2606 OID 18760)
-- Name: site_terms_acceptance site_terms_acceptance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.site_terms_acceptance
    ADD CONSTRAINT site_terms_acceptance_pkey PRIMARY KEY (id);


--
-- TOC entry 4499 (class 2606 OID 18168)
-- Name: team_invites team_invites_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_invites
    ADD CONSTRAINT team_invites_pkey PRIMARY KEY (id);


--
-- TOC entry 4554 (class 2606 OID 19839)
-- Name: team_members team_members_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT team_members_pkey PRIMARY KEY (id);


--
-- TOC entry 4556 (class 2606 OID 19841)
-- Name: team_members team_members_team_id_profile_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT team_members_team_id_profile_id_key UNIQUE (team_id, profile_id);


--
-- TOC entry 4423 (class 2606 OID 17727)
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- TOC entry 4425 (class 2606 OID 20281)
-- Name: teams teams_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_slug_key UNIQUE (slug);


--
-- TOC entry 4428 (class 2606 OID 17729)
-- Name: teams teams_tournament_id_tag_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_tournament_id_tag_key UNIQUE (tournament_id, tag);


--
-- TOC entry 4560 (class 2606 OID 19932)
-- Name: tournament_match_results tournament_match_results_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tournament_match_results
    ADD CONSTRAINT tournament_match_results_pkey PRIMARY KEY (id);


--
-- TOC entry 4562 (class 2606 OID 19934)
-- Name: tournament_match_results tournament_match_results_tournament_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tournament_match_results
    ADD CONSTRAINT tournament_match_results_tournament_code_key UNIQUE (tournament_code);


--
-- TOC entry 4503 (class 2606 OID 18224)
-- Name: tournament_rules tournament_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tournament_rules
    ADD CONSTRAINT tournament_rules_pkey PRIMARY KEY (id);


--
-- TOC entry 4462 (class 2606 OID 17879)
-- Name: tournament_stages tournament_stages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tournament_stages
    ADD CONSTRAINT tournament_stages_pkey PRIMARY KEY (id);


--
-- TOC entry 4418 (class 2606 OID 17712)
-- Name: tournaments tournaments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tournaments
    ADD CONSTRAINT tournaments_pkey PRIMARY KEY (id);


--
-- TOC entry 4421 (class 2606 OID 18605)
-- Name: tournaments tournaments_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tournaments
    ADD CONSTRAINT tournaments_slug_key UNIQUE (slug);


--
-- TOC entry 4546 (class 2606 OID 18762)
-- Name: site_terms_acceptance uq_profile_terms_version; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.site_terms_acceptance
    ADD CONSTRAINT uq_profile_terms_version UNIQUE (profile_id, terms_version);


--
-- TOC entry 4412 (class 2606 OID 17543)
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4529 (class 2606 OID 18574)
-- Name: messages_2026_04_24 messages_2026_04_24_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_04_24
    ADD CONSTRAINT messages_2026_04_24_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4532 (class 2606 OID 18586)
-- Name: messages_2026_04_25 messages_2026_04_25_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_04_25
    ADD CONSTRAINT messages_2026_04_25_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4535 (class 2606 OID 18598)
-- Name: messages_2026_04_26 messages_2026_04_26_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_04_26
    ADD CONSTRAINT messages_2026_04_26_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4538 (class 2606 OID 18621)
-- Name: messages_2026_04_27 messages_2026_04_27_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_04_27
    ADD CONSTRAINT messages_2026_04_27_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4541 (class 2606 OID 18716)
-- Name: messages_2026_04_28 messages_2026_04_28_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_04_28
    ADD CONSTRAINT messages_2026_04_28_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4549 (class 2606 OID 18793)
-- Name: messages_2026_04_29 messages_2026_04_29_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_04_29
    ADD CONSTRAINT messages_2026_04_29_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4565 (class 2606 OID 20292)
-- Name: messages_2026_04_30 messages_2026_04_30_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_04_30
    ADD CONSTRAINT messages_2026_04_30_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4408 (class 2606 OID 17397)
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- TOC entry 4405 (class 2606 OID 17370)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4397 (class 2606 OID 17342)
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- TOC entry 4384 (class 2606 OID 17184)
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- TOC entry 4400 (class 2606 OID 17318)
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- TOC entry 4379 (class 2606 OID 17175)
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- TOC entry 4381 (class 2606 OID 17173)
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 4390 (class 2606 OID 17196)
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- TOC entry 4395 (class 2606 OID 17258)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- TOC entry 4393 (class 2606 OID 17243)
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- TOC entry 4403 (class 2606 OID 17328)
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- TOC entry 4510 (class 2606 OID 18265)
-- Name: schema_migrations schema_migrations_idempotency_key_key; Type: CONSTRAINT; Schema: supabase_migrations; Owner: postgres
--

ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_idempotency_key_key UNIQUE (idempotency_key);


--
-- TOC entry 4512 (class 2606 OID 18263)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: postgres
--

ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4281 (class 1259 OID 16536)
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- TOC entry 4251 (class 1259 OID 16707)
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4362 (class 1259 OID 17123)
-- Name: custom_oauth_providers_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_created_at_idx ON auth.custom_oauth_providers USING btree (created_at);


--
-- TOC entry 4363 (class 1259 OID 17122)
-- Name: custom_oauth_providers_enabled_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_enabled_idx ON auth.custom_oauth_providers USING btree (enabled);


--
-- TOC entry 4364 (class 1259 OID 17120)
-- Name: custom_oauth_providers_identifier_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_identifier_idx ON auth.custom_oauth_providers USING btree (identifier);


--
-- TOC entry 4369 (class 1259 OID 17121)
-- Name: custom_oauth_providers_provider_type_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_provider_type_idx ON auth.custom_oauth_providers USING btree (provider_type);


--
-- TOC entry 4252 (class 1259 OID 16709)
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4253 (class 1259 OID 16710)
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4299 (class 1259 OID 16789)
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- TOC entry 4332 (class 1259 OID 16897)
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- TOC entry 4287 (class 1259 OID 16877)
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- TOC entry 5118 (class 0 OID 0)
-- Dependencies: 4287
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- TOC entry 4292 (class 1259 OID 16704)
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- TOC entry 4335 (class 1259 OID 16894)
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- TOC entry 4359 (class 1259 OID 17079)
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- TOC entry 4336 (class 1259 OID 16895)
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- TOC entry 4254 (class 1259 OID 17165)
-- Name: idx_users_created_at_desc; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_users_created_at_desc ON auth.users USING btree (created_at DESC);


--
-- TOC entry 4255 (class 1259 OID 17164)
-- Name: idx_users_email; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_users_email ON auth.users USING btree (email);


--
-- TOC entry 4256 (class 1259 OID 17166)
-- Name: idx_users_last_sign_in_at_desc; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_users_last_sign_in_at_desc ON auth.users USING btree (last_sign_in_at DESC);


--
-- TOC entry 4257 (class 1259 OID 17167)
-- Name: idx_users_name; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_users_name ON auth.users USING btree (((raw_user_meta_data ->> 'name'::text))) WHERE ((raw_user_meta_data ->> 'name'::text) IS NOT NULL);


--
-- TOC entry 4307 (class 1259 OID 16900)
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- TOC entry 4304 (class 1259 OID 16761)
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- TOC entry 4305 (class 1259 OID 16906)
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- TOC entry 4345 (class 1259 OID 17031)
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- TOC entry 4342 (class 1259 OID 16984)
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- TOC entry 4352 (class 1259 OID 17057)
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- TOC entry 4353 (class 1259 OID 17055)
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- TOC entry 4358 (class 1259 OID 17056)
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- TOC entry 4339 (class 1259 OID 16953)
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- TOC entry 4340 (class 1259 OID 16952)
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- TOC entry 4341 (class 1259 OID 16954)
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- TOC entry 4258 (class 1259 OID 16711)
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4259 (class 1259 OID 16708)
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4268 (class 1259 OID 16519)
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- TOC entry 4269 (class 1259 OID 16520)
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- TOC entry 4270 (class 1259 OID 16703)
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- TOC entry 4273 (class 1259 OID 16791)
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- TOC entry 4276 (class 1259 OID 16896)
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- TOC entry 4326 (class 1259 OID 16833)
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- TOC entry 4327 (class 1259 OID 16898)
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- TOC entry 4328 (class 1259 OID 16848)
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- TOC entry 4331 (class 1259 OID 16847)
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- TOC entry 4293 (class 1259 OID 16899)
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- TOC entry 4294 (class 1259 OID 17069)
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- TOC entry 4297 (class 1259 OID 16790)
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- TOC entry 4318 (class 1259 OID 16815)
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- TOC entry 4321 (class 1259 OID 16814)
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- TOC entry 4316 (class 1259 OID 16800)
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- TOC entry 4317 (class 1259 OID 16962)
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- TOC entry 4306 (class 1259 OID 16959)
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- TOC entry 4298 (class 1259 OID 16788)
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- TOC entry 4260 (class 1259 OID 16868)
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- TOC entry 5119 (class 0 OID 0)
-- Dependencies: 4260
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- TOC entry 4261 (class 1259 OID 16705)
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- TOC entry 4262 (class 1259 OID 16509)
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- TOC entry 4263 (class 1259 OID 16923)
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- TOC entry 4374 (class 1259 OID 17163)
-- Name: webauthn_challenges_expires_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_expires_at_idx ON auth.webauthn_challenges USING btree (expires_at);


--
-- TOC entry 4377 (class 1259 OID 17162)
-- Name: webauthn_challenges_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_user_id_idx ON auth.webauthn_challenges USING btree (user_id);


--
-- TOC entry 4370 (class 1259 OID 17145)
-- Name: webauthn_credentials_credential_id_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX webauthn_credentials_credential_id_key ON auth.webauthn_credentials USING btree (credential_id);


--
-- TOC entry 4373 (class 1259 OID 17146)
-- Name: webauthn_credentials_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_credentials_user_id_idx ON auth.webauthn_credentials USING btree (user_id);


--
-- TOC entry 4506 (class 1259 OID 18250)
-- Name: idx_audit_log_admin_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_log_admin_id ON public.audit_log USING btree (admin_id);


--
-- TOC entry 4507 (class 1259 OID 18249)
-- Name: idx_audit_log_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_log_created_at ON public.audit_log USING btree (created_at DESC);


--
-- TOC entry 4508 (class 1259 OID 18251)
-- Name: idx_audit_log_table_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_log_table_name ON public.audit_log USING btree (table_name);


--
-- TOC entry 4526 (class 1259 OID 18503)
-- Name: idx_champion_masteries_account; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_champion_masteries_account ON public.champion_masteries USING btree (riot_account_id);


--
-- TOC entry 4440 (class 1259 OID 18540)
-- Name: idx_inscricoes_requested_by; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inscricoes_requested_by ON public.inscricoes USING btree (requested_by);


--
-- TOC entry 4441 (class 1259 OID 18541)
-- Name: idx_inscricoes_requested_by_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inscricoes_requested_by_status ON public.inscricoes USING btree (requested_by, status);


--
-- TOC entry 4442 (class 1259 OID 18538)
-- Name: idx_inscricoes_team_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inscricoes_team_id ON public.inscricoes USING btree (team_id);


--
-- TOC entry 4443 (class 1259 OID 19803)
-- Name: idx_inscricoes_tournament_checkin; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inscricoes_tournament_checkin ON public.inscricoes USING btree (tournament_id, checked_in);


--
-- TOC entry 4444 (class 1259 OID 18539)
-- Name: idx_inscricoes_tournament_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inscricoes_tournament_id ON public.inscricoes USING btree (tournament_id);


--
-- TOC entry 4445 (class 1259 OID 18341)
-- Name: idx_inscricoes_tournament_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inscricoes_tournament_status ON public.inscricoes USING btree (tournament_id, status);


--
-- TOC entry 4463 (class 1259 OID 17918)
-- Name: idx_match_games_match; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_match_games_match ON public.match_games USING btree (match_id);


--
-- TOC entry 4450 (class 1259 OID 17838)
-- Name: idx_matches_round; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_matches_round ON public.matches USING btree (tournament_id, round);


--
-- TOC entry 4451 (class 1259 OID 18339)
-- Name: idx_matches_stage_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_matches_stage_id ON public.matches USING btree (stage_id) WHERE (stage_id IS NOT NULL);


--
-- TOC entry 4452 (class 1259 OID 18340)
-- Name: idx_matches_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_matches_status ON public.matches USING btree (status);


--
-- TOC entry 4453 (class 1259 OID 20321)
-- Name: idx_matches_team_a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_matches_team_a ON public.matches USING btree (team_a_id);


--
-- TOC entry 4454 (class 1259 OID 20322)
-- Name: idx_matches_team_b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_matches_team_b ON public.matches USING btree (team_b_id);


--
-- TOC entry 4455 (class 1259 OID 17837)
-- Name: idx_matches_tournament; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_matches_tournament ON public.matches USING btree (tournament_id);


--
-- TOC entry 4456 (class 1259 OID 18338)
-- Name: idx_matches_tournament_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_matches_tournament_id ON public.matches USING btree (tournament_id);


--
-- TOC entry 4457 (class 1259 OID 19905)
-- Name: idx_matches_tournament_round; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_matches_tournament_round ON public.matches USING btree (tournament_id, round, match_number);


--
-- TOC entry 4476 (class 1259 OID 17994)
-- Name: idx_notifications_expires; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_expires ON public.notifications USING btree (expires_at);


--
-- TOC entry 4477 (class 1259 OID 18525)
-- Name: idx_notifications_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_type ON public.notifications USING btree (type);


--
-- TOC entry 4478 (class 1259 OID 17993)
-- Name: idx_notifications_unread; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_unread ON public.notifications USING btree (user_id) WHERE (read = false);


--
-- TOC entry 4479 (class 1259 OID 17992)
-- Name: idx_notifications_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_user ON public.notifications USING btree (user_id);


--
-- TOC entry 4480 (class 1259 OID 18524)
-- Name: idx_notifications_user_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_user_created_at ON public.notifications USING btree (user_id, created_at DESC);


--
-- TOC entry 4481 (class 1259 OID 18342)
-- Name: idx_notifications_user_unread; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_user_unread ON public.notifications USING btree (user_id, read) WHERE (read = false);


--
-- TOC entry 4468 (class 1259 OID 17956)
-- Name: idx_player_stats_game; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_player_stats_game ON public.player_stats USING btree (game_id);


--
-- TOC entry 4469 (class 1259 OID 18337)
-- Name: idx_player_stats_game_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_player_stats_game_id ON public.player_stats USING btree (game_id);


--
-- TOC entry 4470 (class 1259 OID 17957)
-- Name: idx_player_stats_player; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_player_stats_player ON public.player_stats USING btree (player_id);


--
-- TOC entry 4471 (class 1259 OID 18336)
-- Name: idx_player_stats_player_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_player_stats_player_id ON public.player_stats USING btree (player_id);


--
-- TOC entry 4472 (class 1259 OID 17958)
-- Name: idx_player_stats_team; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_player_stats_team ON public.player_stats USING btree (team_id);


--
-- TOC entry 4473 (class 1259 OID 20319)
-- Name: idx_player_stats_team_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_player_stats_team_id ON public.player_stats USING btree (team_id);


--
-- TOC entry 4429 (class 1259 OID 18348)
-- Name: idx_players_last_synced; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_players_last_synced ON public.players USING btree (last_synced) WHERE (last_synced IS NOT NULL);


--
-- TOC entry 4430 (class 1259 OID 17768)
-- Name: idx_players_name_trgm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_players_name_trgm ON public.players USING gin (summoner_name public.gin_trgm_ops);


--
-- TOC entry 4431 (class 1259 OID 17767)
-- Name: idx_players_puuid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_players_puuid ON public.players USING btree (puuid);


--
-- TOC entry 4432 (class 1259 OID 18537)
-- Name: idx_players_summoner_name_trgm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_players_summoner_name_trgm ON public.players USING gin (summoner_name public.gin_trgm_ops);


--
-- TOC entry 4433 (class 1259 OID 20320)
-- Name: idx_players_tag_line; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_players_tag_line ON public.players USING btree (tag_line);


--
-- TOC entry 4434 (class 1259 OID 17766)
-- Name: idx_players_team_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_players_team_id ON public.players USING btree (team_id);


--
-- TOC entry 4435 (class 1259 OID 18536)
-- Name: idx_players_team_role; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_players_team_role ON public.players USING btree (team_id, role);


--
-- TOC entry 4518 (class 1259 OID 18483)
-- Name: idx_rank_snapshots_account_queue; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rank_snapshots_account_queue ON public.rank_snapshots USING btree (riot_account_id, queue_type);


--
-- TOC entry 4519 (class 1259 OID 18482)
-- Name: idx_rank_snapshots_account_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rank_snapshots_account_time ON public.rank_snapshots USING btree (riot_account_id, snapshotted_at DESC);


--
-- TOC entry 4513 (class 1259 OID 18459)
-- Name: idx_riot_accounts_primary_per_profile; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_riot_accounts_primary_per_profile ON public.riot_accounts USING btree (profile_id) WHERE (is_primary = true);


--
-- TOC entry 4514 (class 1259 OID 18460)
-- Name: idx_riot_accounts_profile_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_riot_accounts_profile_id ON public.riot_accounts USING btree (profile_id);


--
-- TOC entry 4515 (class 1259 OID 18458)
-- Name: idx_riot_accounts_puuid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_riot_accounts_puuid ON public.riot_accounts USING btree (puuid);


--
-- TOC entry 4487 (class 1259 OID 18345)
-- Name: idx_seedings_seed; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_seedings_seed ON public.seedings USING btree (tournament_id, seed);


--
-- TOC entry 4488 (class 1259 OID 18344)
-- Name: idx_seedings_tournament; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_seedings_tournament ON public.seedings USING btree (tournament_id);


--
-- TOC entry 4542 (class 1259 OID 18768)
-- Name: idx_site_terms_acceptance_profile; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_site_terms_acceptance_profile ON public.site_terms_acceptance USING btree (profile_id);


--
-- TOC entry 4460 (class 1259 OID 17885)
-- Name: idx_stages_tournament; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_stages_tournament ON public.tournament_stages USING btree (tournament_id);


--
-- TOC entry 4495 (class 1259 OID 19915)
-- Name: idx_team_invites_expires; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_team_invites_expires ON public.team_invites USING btree (expires_at) WHERE (status = 'PENDING'::public.invite_status);


--
-- TOC entry 4496 (class 1259 OID 19914)
-- Name: idx_team_invites_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_team_invites_status ON public.team_invites USING btree (status);


--
-- TOC entry 4497 (class 1259 OID 19913)
-- Name: idx_team_invites_team; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_team_invites_team ON public.team_invites USING btree (team_id);


--
-- TOC entry 4550 (class 1259 OID 19863)
-- Name: idx_team_members_profile; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_team_members_profile ON public.team_members USING btree (profile_id);


--
-- TOC entry 4551 (class 1259 OID 19864)
-- Name: idx_team_members_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_team_members_status ON public.team_members USING btree (status);


--
-- TOC entry 4552 (class 1259 OID 19862)
-- Name: idx_team_members_team; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_team_members_team ON public.team_members USING btree (team_id);


--
-- TOC entry 4415 (class 1259 OID 18779)
-- Name: idx_tournaments_organizer; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tournaments_organizer ON public.tournaments USING btree (organizer_id);


--
-- TOC entry 4416 (class 1259 OID 18606)
-- Name: idx_tournaments_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tournaments_slug ON public.tournaments USING btree (slug);


--
-- TOC entry 4484 (class 1259 OID 18433)
-- Name: notifications_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX notifications_user_id_idx ON public.notifications USING btree (user_id, created_at DESC);


--
-- TOC entry 4426 (class 1259 OID 20283)
-- Name: teams_slug_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX teams_slug_unique ON public.teams USING btree (slug) WHERE (slug IS NOT NULL);


--
-- TOC entry 4419 (class 1259 OID 18320)
-- Name: tournaments_slug_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tournaments_slug_idx ON public.tournaments USING btree (slug);


--
-- TOC entry 4406 (class 1259 OID 17544)
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- TOC entry 4410 (class 1259 OID 17545)
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4527 (class 1259 OID 18575)
-- Name: messages_2026_04_24_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_04_24_inserted_at_topic_idx ON realtime.messages_2026_04_24 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4530 (class 1259 OID 18587)
-- Name: messages_2026_04_25_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_04_25_inserted_at_topic_idx ON realtime.messages_2026_04_25 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4533 (class 1259 OID 18599)
-- Name: messages_2026_04_26_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_04_26_inserted_at_topic_idx ON realtime.messages_2026_04_26 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4536 (class 1259 OID 18622)
-- Name: messages_2026_04_27_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_04_27_inserted_at_topic_idx ON realtime.messages_2026_04_27 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4539 (class 1259 OID 18717)
-- Name: messages_2026_04_28_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_04_28_inserted_at_topic_idx ON realtime.messages_2026_04_28 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4547 (class 1259 OID 18794)
-- Name: messages_2026_04_29_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_04_29_inserted_at_topic_idx ON realtime.messages_2026_04_29 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4563 (class 1259 OID 20293)
-- Name: messages_2026_04_30_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_04_30_inserted_at_topic_idx ON realtime.messages_2026_04_30 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4409 (class 1259 OID 17548)
-- Name: subscription_subscription_id_entity_filters_action_filter_key; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_key ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter);


--
-- TOC entry 4382 (class 1259 OID 17185)
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- TOC entry 4385 (class 1259 OID 17202)
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- TOC entry 4398 (class 1259 OID 17343)
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- TOC entry 4391 (class 1259 OID 17269)
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- TOC entry 4386 (class 1259 OID 17234)
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- TOC entry 4387 (class 1259 OID 17350)
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- TOC entry 4388 (class 1259 OID 17203)
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- TOC entry 4401 (class 1259 OID 17334)
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- TOC entry 4566 (class 0 OID 0)
-- Name: messages_2026_04_24_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_04_24_inserted_at_topic_idx;


--
-- TOC entry 4567 (class 0 OID 0)
-- Name: messages_2026_04_24_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_04_24_pkey;


--
-- TOC entry 4568 (class 0 OID 0)
-- Name: messages_2026_04_25_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_04_25_inserted_at_topic_idx;


--
-- TOC entry 4569 (class 0 OID 0)
-- Name: messages_2026_04_25_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_04_25_pkey;


--
-- TOC entry 4570 (class 0 OID 0)
-- Name: messages_2026_04_26_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_04_26_inserted_at_topic_idx;


--
-- TOC entry 4571 (class 0 OID 0)
-- Name: messages_2026_04_26_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_04_26_pkey;


--
-- TOC entry 4572 (class 0 OID 0)
-- Name: messages_2026_04_27_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_04_27_inserted_at_topic_idx;


--
-- TOC entry 4573 (class 0 OID 0)
-- Name: messages_2026_04_27_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_04_27_pkey;


--
-- TOC entry 4574 (class 0 OID 0)
-- Name: messages_2026_04_28_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_04_28_inserted_at_topic_idx;


--
-- TOC entry 4575 (class 0 OID 0)
-- Name: messages_2026_04_28_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_04_28_pkey;


--
-- TOC entry 4576 (class 0 OID 0)
-- Name: messages_2026_04_29_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_04_29_inserted_at_topic_idx;


--
-- TOC entry 4577 (class 0 OID 0)
-- Name: messages_2026_04_29_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_04_29_pkey;


--
-- TOC entry 4578 (class 0 OID 0)
-- Name: messages_2026_04_30_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_04_30_inserted_at_topic_idx;


--
-- TOC entry 4579 (class 0 OID 0)
-- Name: messages_2026_04_30_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_04_30_pkey;


--
-- TOC entry 4647 (class 2620 OID 17698)
-- Name: users on_auth_user_created; Type: TRIGGER; Schema: auth; Owner: supabase_auth_admin
--

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


--
-- TOC entry 4661 (class 2620 OID 18254)
-- Name: matches audit_matches_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER audit_matches_trigger AFTER INSERT OR UPDATE ON public.matches FOR EACH ROW EXECUTE FUNCTION public.audit_matches_changes();


--
-- TOC entry 4654 (class 2620 OID 18322)
-- Name: tournaments set_tournament_slug; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tournament_slug BEFORE INSERT OR UPDATE ON public.tournaments FOR EACH ROW EXECUTE FUNCTION public.generate_tournament_slug();


--
-- TOC entry 4657 (class 2620 OID 19894)
-- Name: teams trg_auto_captain; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_auto_captain AFTER INSERT ON public.teams FOR EACH ROW EXECUTE FUNCTION public.auto_add_captain_as_member();


--
-- TOC entry 4669 (class 2620 OID 18504)
-- Name: champion_masteries trg_champion_masteries_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_champion_masteries_updated_at BEFORE UPDATE ON public.champion_masteries FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4666 (class 2620 OID 19922)
-- Name: team_invites trg_expire_invite; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_expire_invite BEFORE INSERT OR UPDATE ON public.team_invites FOR EACH ROW EXECUTE FUNCTION public.expire_pending_invites();


--
-- TOC entry 4659 (class 2620 OID 19911)
-- Name: inscricoes trg_inscricao_nova; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_inscricao_nova AFTER INSERT ON public.inscricoes FOR EACH ROW EXECUTE FUNCTION public.fn_notify_inscricao();


--
-- TOC entry 4660 (class 2620 OID 19912)
-- Name: inscricoes trg_inscricao_status_change; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_inscricao_status_change AFTER UPDATE OF status ON public.inscricoes FOR EACH ROW EXECUTE FUNCTION public.fn_notify_inscricao();


--
-- TOC entry 4662 (class 2620 OID 18533)
-- Name: matches trg_match_finished; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_match_finished AFTER UPDATE ON public.matches FOR EACH ROW EXECUTE FUNCTION public.trg_match_finished();


--
-- TOC entry 4663 (class 2620 OID 17843)
-- Name: matches trg_matches_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_matches_updated_at BEFORE UPDATE ON public.matches FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4665 (class 2620 OID 18523)
-- Name: notifications trg_notifications_sync_body_message; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_notifications_sync_body_message BEFORE INSERT OR UPDATE ON public.notifications FOR EACH ROW EXECUTE FUNCTION public.sync_notifications_body_message();


--
-- TOC entry 4658 (class 2620 OID 17842)
-- Name: players trg_players_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_players_updated_at BEFORE UPDATE ON public.players FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4653 (class 2620 OID 17840)
-- Name: profiles trg_profiles_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_profiles_updated_at BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4667 (class 2620 OID 18463)
-- Name: riot_accounts trg_riot_accounts_primary; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_riot_accounts_primary BEFORE INSERT OR UPDATE ON public.riot_accounts FOR EACH ROW EXECUTE FUNCTION public.ensure_single_primary_riot_account();


--
-- TOC entry 4668 (class 2620 OID 18462)
-- Name: riot_accounts trg_riot_accounts_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_riot_accounts_updated_at BEFORE UPDATE ON public.riot_accounts FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4664 (class 2620 OID 17886)
-- Name: tournament_stages trg_stages_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_stages_updated_at BEFORE UPDATE ON public.tournament_stages FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4655 (class 2620 OID 18534)
-- Name: tournaments trg_tournament_started; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_tournament_started AFTER UPDATE ON public.tournaments FOR EACH ROW EXECUTE FUNCTION public.trg_tournament_started();


--
-- TOC entry 4656 (class 2620 OID 17841)
-- Name: tournaments trg_tournaments_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_tournaments_updated_at BEFORE UPDATE ON public.tournaments FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4652 (class 2620 OID 17402)
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- TOC entry 4648 (class 2620 OID 17288)
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- TOC entry 4649 (class 2620 OID 17352)
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- TOC entry 4650 (class 2620 OID 17353)
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- TOC entry 4651 (class 2620 OID 17222)
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- TOC entry 4581 (class 2606 OID 16691)
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4586 (class 2606 OID 16781)
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- TOC entry 4585 (class 2606 OID 16769)
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- TOC entry 4584 (class 2606 OID 16756)
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4592 (class 2606 OID 17021)
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4593 (class 2606 OID 17026)
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4594 (class 2606 OID 17050)
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4595 (class 2606 OID 17045)
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4591 (class 2606 OID 16947)
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4580 (class 2606 OID 16724)
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- TOC entry 4588 (class 2606 OID 16828)
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4589 (class 2606 OID 16901)
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- TOC entry 4590 (class 2606 OID 16842)
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4582 (class 2606 OID 17064)
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4583 (class 2606 OID 16719)
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4587 (class 2606 OID 16809)
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4597 (class 2606 OID 17157)
-- Name: webauthn_challenges webauthn_challenges_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4596 (class 2606 OID 17140)
-- Name: webauthn_credentials webauthn_credentials_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4645 (class 2606 OID 19871)
-- Name: active_team active_team_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_team
    ADD CONSTRAINT active_team_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- TOC entry 4646 (class 2606 OID 19876)
-- Name: active_team active_team_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_team
    ADD CONSTRAINT active_team_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE SET NULL;


--
-- TOC entry 4636 (class 2606 OID 18242)
-- Name: audit_log audit_log_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- TOC entry 4639 (class 2606 OID 18498)
-- Name: champion_masteries champion_masteries_riot_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.champion_masteries
    ADD CONSTRAINT champion_masteries_riot_account_id_fkey FOREIGN KEY (riot_account_id) REFERENCES public.riot_accounts(id) ON DELETE CASCADE;


--
-- TOC entry 4632 (class 2606 OID 18200)
-- Name: disputes disputes_match_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disputes
    ADD CONSTRAINT disputes_match_id_fkey FOREIGN KEY (match_id) REFERENCES public.matches(id) ON DELETE CASCADE;


--
-- TOC entry 4633 (class 2606 OID 18205)
-- Name: disputes disputes_reported_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disputes
    ADD CONSTRAINT disputes_reported_by_fkey FOREIGN KEY (reported_by) REFERENCES public.profiles(id);


--
-- TOC entry 4634 (class 2606 OID 18210)
-- Name: disputes disputes_resolved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disputes
    ADD CONSTRAINT disputes_resolved_by_fkey FOREIGN KEY (resolved_by) REFERENCES public.profiles(id);


--
-- TOC entry 4610 (class 2606 OID 19798)
-- Name: inscricoes inscricoes_checked_in_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inscricoes
    ADD CONSTRAINT inscricoes_checked_in_by_fkey FOREIGN KEY (checked_in_by) REFERENCES auth.users(id);


--
-- TOC entry 4611 (class 2606 OID 17791)
-- Name: inscricoes inscricoes_requested_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inscricoes
    ADD CONSTRAINT inscricoes_requested_by_fkey FOREIGN KEY (requested_by) REFERENCES public.profiles(id) ON DELETE SET NULL;


--
-- TOC entry 4612 (class 2606 OID 17796)
-- Name: inscricoes inscricoes_reviewed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inscricoes
    ADD CONSTRAINT inscricoes_reviewed_by_fkey FOREIGN KEY (reviewed_by) REFERENCES public.profiles(id) ON DELETE SET NULL;


--
-- TOC entry 4613 (class 2606 OID 17786)
-- Name: inscricoes inscricoes_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inscricoes
    ADD CONSTRAINT inscricoes_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE;


--
-- TOC entry 4614 (class 2606 OID 17781)
-- Name: inscricoes inscricoes_tournament_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inscricoes
    ADD CONSTRAINT inscricoes_tournament_id_fkey FOREIGN KEY (tournament_id) REFERENCES public.tournaments(id) ON DELETE CASCADE;


--
-- TOC entry 4621 (class 2606 OID 17908)
-- Name: match_games match_games_match_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_games
    ADD CONSTRAINT match_games_match_id_fkey FOREIGN KEY (match_id) REFERENCES public.matches(id) ON DELETE CASCADE;


--
-- TOC entry 4622 (class 2606 OID 17913)
-- Name: match_games match_games_winner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_games
    ADD CONSTRAINT match_games_winner_id_fkey FOREIGN KEY (winner_id) REFERENCES public.teams(id) ON DELETE SET NULL;


--
-- TOC entry 4615 (class 2606 OID 17889)
-- Name: matches matches_stage_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_stage_id_fkey FOREIGN KEY (stage_id) REFERENCES public.tournament_stages(id) ON DELETE SET NULL;


--
-- TOC entry 4616 (class 2606 OID 17822)
-- Name: matches matches_team_a_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_team_a_id_fkey FOREIGN KEY (team_a_id) REFERENCES public.teams(id) ON DELETE SET NULL;


--
-- TOC entry 4617 (class 2606 OID 17827)
-- Name: matches matches_team_b_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_team_b_id_fkey FOREIGN KEY (team_b_id) REFERENCES public.teams(id) ON DELETE SET NULL;


--
-- TOC entry 4618 (class 2606 OID 17817)
-- Name: matches matches_tournament_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_tournament_id_fkey FOREIGN KEY (tournament_id) REFERENCES public.tournaments(id) ON DELETE CASCADE;


--
-- TOC entry 4619 (class 2606 OID 17832)
-- Name: matches matches_winner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_winner_id_fkey FOREIGN KEY (winner_id) REFERENCES public.teams(id) ON DELETE SET NULL;


--
-- TOC entry 4626 (class 2606 OID 18517)
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- TOC entry 4623 (class 2606 OID 17941)
-- Name: player_stats player_stats_game_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.player_stats
    ADD CONSTRAINT player_stats_game_id_fkey FOREIGN KEY (game_id) REFERENCES public.match_games(id) ON DELETE CASCADE;


--
-- TOC entry 4624 (class 2606 OID 17946)
-- Name: player_stats player_stats_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.player_stats
    ADD CONSTRAINT player_stats_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.players(id) ON DELETE SET NULL;


--
-- TOC entry 4625 (class 2606 OID 17951)
-- Name: player_stats player_stats_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.player_stats
    ADD CONSTRAINT player_stats_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE SET NULL;


--
-- TOC entry 4608 (class 2606 OID 20311)
-- Name: players players_riot_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_riot_account_id_fkey FOREIGN KEY (riot_account_id) REFERENCES public.riot_accounts(id);


--
-- TOC entry 4609 (class 2606 OID 17761)
-- Name: players players_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE SET NULL;


--
-- TOC entry 4627 (class 2606 OID 18116)
-- Name: prize_distribution prize_distribution_tournament_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prize_distribution
    ADD CONSTRAINT prize_distribution_tournament_id_fkey FOREIGN KEY (tournament_id) REFERENCES public.tournaments(id) ON DELETE CASCADE;


--
-- TOC entry 4603 (class 2606 OID 17692)
-- Name: profiles profiles_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4638 (class 2606 OID 18477)
-- Name: rank_snapshots rank_snapshots_riot_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rank_snapshots
    ADD CONSTRAINT rank_snapshots_riot_account_id_fkey FOREIGN KEY (riot_account_id) REFERENCES public.riot_accounts(id) ON DELETE CASCADE;


--
-- TOC entry 4637 (class 2606 OID 18453)
-- Name: riot_accounts riot_accounts_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.riot_accounts
    ADD CONSTRAINT riot_accounts_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- TOC entry 4628 (class 2606 OID 18142)
-- Name: seedings seedings_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seedings
    ADD CONSTRAINT seedings_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE;


--
-- TOC entry 4629 (class 2606 OID 18137)
-- Name: seedings seedings_tournament_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seedings
    ADD CONSTRAINT seedings_tournament_id_fkey FOREIGN KEY (tournament_id) REFERENCES public.tournaments(id) ON DELETE CASCADE;


--
-- TOC entry 4640 (class 2606 OID 18763)
-- Name: site_terms_acceptance site_terms_acceptance_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.site_terms_acceptance
    ADD CONSTRAINT site_terms_acceptance_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- TOC entry 4630 (class 2606 OID 18174)
-- Name: team_invites team_invites_invited_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_invites
    ADD CONSTRAINT team_invites_invited_by_fkey FOREIGN KEY (invited_by) REFERENCES public.profiles(id);


--
-- TOC entry 4631 (class 2606 OID 18169)
-- Name: team_invites team_invites_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_invites
    ADD CONSTRAINT team_invites_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE;


--
-- TOC entry 4641 (class 2606 OID 19857)
-- Name: team_members team_members_invited_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT team_members_invited_by_fkey FOREIGN KEY (invited_by) REFERENCES public.profiles(id) ON DELETE SET NULL;


--
-- TOC entry 4642 (class 2606 OID 19847)
-- Name: team_members team_members_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT team_members_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- TOC entry 4643 (class 2606 OID 19852)
-- Name: team_members team_members_riot_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT team_members_riot_account_id_fkey FOREIGN KEY (riot_account_id) REFERENCES public.riot_accounts(id) ON DELETE SET NULL;


--
-- TOC entry 4644 (class 2606 OID 19842)
-- Name: team_members team_members_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT team_members_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE;


--
-- TOC entry 4606 (class 2606 OID 17735)
-- Name: teams teams_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.profiles(id) ON DELETE SET NULL;


--
-- TOC entry 4607 (class 2606 OID 17730)
-- Name: teams teams_tournament_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_tournament_id_fkey FOREIGN KEY (tournament_id) REFERENCES public.tournaments(id) ON DELETE CASCADE;


--
-- TOC entry 4635 (class 2606 OID 18225)
-- Name: tournament_rules tournament_rules_tournament_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tournament_rules
    ADD CONSTRAINT tournament_rules_tournament_id_fkey FOREIGN KEY (tournament_id) REFERENCES public.tournaments(id) ON DELETE CASCADE;


--
-- TOC entry 4620 (class 2606 OID 17880)
-- Name: tournament_stages tournament_stages_tournament_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tournament_stages
    ADD CONSTRAINT tournament_stages_tournament_id_fkey FOREIGN KEY (tournament_id) REFERENCES public.tournaments(id) ON DELETE CASCADE;


--
-- TOC entry 4604 (class 2606 OID 17713)
-- Name: tournaments tournaments_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tournaments
    ADD CONSTRAINT tournaments_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(id) ON DELETE SET NULL;


--
-- TOC entry 4605 (class 2606 OID 18774)
-- Name: tournaments tournaments_organizer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tournaments
    ADD CONSTRAINT tournaments_organizer_id_fkey FOREIGN KEY (organizer_id) REFERENCES public.profiles(id) ON DELETE SET NULL;


--
-- TOC entry 4598 (class 2606 OID 17197)
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4599 (class 2606 OID 17244)
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4600 (class 2606 OID 17264)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4601 (class 2606 OID 17259)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- TOC entry 4602 (class 2606 OID 17329)
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- TOC entry 4824 (class 0 OID 16529)
-- Dependencies: 334
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4835 (class 0 OID 16887)
-- Dependencies: 347
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4826 (class 0 OID 16684)
-- Dependencies: 338
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4823 (class 0 OID 16522)
-- Dependencies: 333
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4830 (class 0 OID 16774)
-- Dependencies: 342
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4829 (class 0 OID 16762)
-- Dependencies: 341
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4828 (class 0 OID 16749)
-- Dependencies: 340
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4836 (class 0 OID 16937)
-- Dependencies: 348
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4822 (class 0 OID 16511)
-- Dependencies: 332
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4833 (class 0 OID 16816)
-- Dependencies: 345
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4834 (class 0 OID 16834)
-- Dependencies: 346
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4825 (class 0 OID 16537)
-- Dependencies: 335
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4827 (class 0 OID 16714)
-- Dependencies: 339
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4832 (class 0 OID 16801)
-- Dependencies: 344
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4831 (class 0 OID 16792)
-- Dependencies: 343
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4821 (class 0 OID 16499)
-- Dependencies: 330
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4916 (class 3256 OID 18347)
-- Name: seedings Admins can manage seedings; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can manage seedings" ON public.seedings USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.id = auth.uid()) AND (profiles.is_admin = true)))));


--
-- TOC entry 4892 (class 3256 OID 18247)
-- Name: audit_log Admins can view audit log; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can view audit log" ON public.audit_log FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.id = auth.uid()) AND (profiles.is_admin = true)))));


--
-- TOC entry 4915 (class 3256 OID 18346)
-- Name: seedings Public can view seedings; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Public can view seedings" ON public.seedings FOR SELECT USING (true);


--
-- TOC entry 4867 (class 0 OID 19865)
-- Dependencies: 407
-- Name: active_team; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.active_team ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4947 (class 3256 OID 19885)
-- Name: active_team active_team_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY active_team_select ON public.active_team FOR SELECT USING ((profile_id = auth.uid()));


--
-- TOC entry 4948 (class 3256 OID 19886)
-- Name: active_team active_team_upsert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY active_team_upsert ON public.active_team USING ((profile_id = auth.uid()));


--
-- TOC entry 4929 (class 3256 OID 18730)
-- Name: profiles admin_read_all_profiles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY admin_read_all_profiles ON public.profiles FOR SELECT USING (public.is_admin(auth.uid()));


--
-- TOC entry 4940 (class 3256 OID 18771)
-- Name: site_terms_acceptance admin_select_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY admin_select_all ON public.site_terms_acceptance FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.id = auth.uid()) AND (profiles.is_admin = true)))));


--
-- TOC entry 4861 (class 0 OID 18233)
-- Dependencies: 386
-- Name: audit_log; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.audit_log ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4913 (class 3256 OID 18316)
-- Name: audit_log audit_log_insert_service_role; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY audit_log_insert_service_role ON public.audit_log FOR INSERT WITH CHECK ((auth.role() = 'service_role'::text));


--
-- TOC entry 4864 (class 0 OID 18484)
-- Dependencies: 398
-- Name: champion_masteries; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.champion_masteries ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4930 (class 3256 OID 18515)
-- Name: champion_masteries champion_masteries_delete_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY champion_masteries_delete_own ON public.champion_masteries FOR DELETE USING ((EXISTS ( SELECT 1
   FROM public.riot_accounts ra
  WHERE ((ra.id = champion_masteries.riot_account_id) AND (ra.profile_id = auth.uid())))));


--
-- TOC entry 4927 (class 3256 OID 18512)
-- Name: champion_masteries champion_masteries_insert_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY champion_masteries_insert_own ON public.champion_masteries FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM public.riot_accounts ra
  WHERE ((ra.id = champion_masteries.riot_account_id) AND (ra.profile_id = auth.uid())))));


--
-- TOC entry 4926 (class 3256 OID 18511)
-- Name: champion_masteries champion_masteries_select_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY champion_masteries_select_own ON public.champion_masteries FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.riot_accounts ra
  WHERE ((ra.id = champion_masteries.riot_account_id) AND (ra.profile_id = auth.uid())))));


--
-- TOC entry 4928 (class 3256 OID 18513)
-- Name: champion_masteries champion_masteries_update_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY champion_masteries_update_own ON public.champion_masteries FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM public.riot_accounts ra
  WHERE ((ra.id = champion_masteries.riot_account_id) AND (ra.profile_id = auth.uid()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.riot_accounts ra
  WHERE ((ra.id = champion_masteries.riot_account_id) AND (ra.profile_id = auth.uid())))));


--
-- TOC entry 4859 (class 0 OID 18189)
-- Dependencies: 384
-- Name: disputes; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.disputes ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4909 (class 3256 OID 18301)
-- Name: disputes disputes_delete_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY disputes_delete_admin ON public.disputes FOR DELETE USING (public.is_admin(auth.uid()));


--
-- TOC entry 4907 (class 3256 OID 18299)
-- Name: disputes disputes_insert_auth; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY disputes_insert_auth ON public.disputes FOR INSERT WITH CHECK ((auth.uid() = reported_by));


--
-- TOC entry 4906 (class 3256 OID 18298)
-- Name: disputes disputes_select_auth; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY disputes_select_auth ON public.disputes FOR SELECT USING ((auth.role() = 'authenticated'::text));


--
-- TOC entry 4908 (class 3256 OID 18300)
-- Name: disputes disputes_update_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY disputes_update_admin ON public.disputes FOR UPDATE USING (public.is_admin(auth.uid()));


--
-- TOC entry 4850 (class 0 OID 17769)
-- Dependencies: 375
-- Name: inscricoes; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.inscricoes ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4883 (class 3256 OID 17863)
-- Name: inscricoes inscricoes_delete_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY inscricoes_delete_admin ON public.inscricoes FOR DELETE USING (public.is_admin(auth.uid()));


--
-- TOC entry 4958 (class 3256 OID 19901)
-- Name: inscricoes inscricoes_insert_owner; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY inscricoes_insert_owner ON public.inscricoes FOR INSERT WITH CHECK ((auth.uid() = requested_by));


--
-- TOC entry 4882 (class 3256 OID 17861)
-- Name: inscricoes inscricoes_insert_user; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY inscricoes_insert_user ON public.inscricoes FOR INSERT WITH CHECK ((auth.uid() = requested_by));


--
-- TOC entry 4881 (class 3256 OID 17860)
-- Name: inscricoes inscricoes_select_auth; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY inscricoes_select_auth ON public.inscricoes FOR SELECT USING ((auth.role() = 'authenticated'::text));


--
-- TOC entry 4945 (class 3256 OID 19899)
-- Name: inscricoes inscricoes_select_authenticated; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY inscricoes_select_authenticated ON public.inscricoes FOR SELECT USING ((auth.uid() IS NOT NULL));


--
-- TOC entry 4954 (class 3256 OID 19892)
-- Name: inscricoes inscricoes_update_organizer_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY inscricoes_update_organizer_or_admin ON public.inscricoes FOR UPDATE USING ((public.is_admin(auth.uid()) OR public.is_tournament_organizer(auth.uid(), tournament_id)));


--
-- TOC entry 4957 (class 3256 OID 19900)
-- Name: inscricoes inscricoes_update_owner_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY inscricoes_update_owner_or_admin ON public.inscricoes FOR UPDATE USING (((auth.uid() = requested_by) OR public.is_current_user_admin()));


--
-- TOC entry 4853 (class 0 OID 17895)
-- Dependencies: 378
-- Name: match_games; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.match_games ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4889 (class 3256 OID 17998)
-- Name: match_games match_games_all_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY match_games_all_admin ON public.match_games USING (public.is_admin(auth.uid()));


--
-- TOC entry 4888 (class 3256 OID 17997)
-- Name: match_games match_games_select_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY match_games_select_all ON public.match_games FOR SELECT USING (true);


--
-- TOC entry 4851 (class 0 OID 17801)
-- Dependencies: 376
-- Name: matches; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.matches ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4885 (class 3256 OID 17865)
-- Name: matches matches_all_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY matches_all_admin ON public.matches USING (public.is_admin(auth.uid()));


--
-- TOC entry 4960 (class 3256 OID 19906)
-- Name: matches matches_read_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY matches_read_all ON public.matches FOR SELECT USING (true);


--
-- TOC entry 4884 (class 3256 OID 17864)
-- Name: matches matches_select_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY matches_select_all ON public.matches FOR SELECT USING (true);


--
-- TOC entry 4961 (class 3256 OID 19907)
-- Name: matches matches_write_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY matches_write_admin ON public.matches USING (((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.id = auth.uid()) AND (profiles.is_admin = true)))) OR (EXISTS ( SELECT 1
   FROM public.tournaments t
  WHERE ((t.id = matches.tournament_id) AND (t.organizer_id = auth.uid()))))));


--
-- TOC entry 4855 (class 0 OID 17977)
-- Dependencies: 380
-- Name: notifications; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4934 (class 3256 OID 18529)
-- Name: notifications notifications_delete_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY notifications_delete_own ON public.notifications FOR DELETE USING ((auth.uid() = user_id));


--
-- TOC entry 4932 (class 3256 OID 18527)
-- Name: notifications notifications_insert_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY notifications_insert_own ON public.notifications FOR INSERT WITH CHECK (((auth.uid() = user_id) OR (auth.role() = 'service_role'::text)));


--
-- TOC entry 4914 (class 3256 OID 18317)
-- Name: notifications notifications_insert_service_role; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY notifications_insert_service_role ON public.notifications FOR INSERT WITH CHECK ((auth.role() = 'service_role'::text));


--
-- TOC entry 4931 (class 3256 OID 18526)
-- Name: notifications notifications_select_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY notifications_select_own ON public.notifications FOR SELECT USING ((auth.uid() = user_id));


--
-- TOC entry 4933 (class 3256 OID 18528)
-- Name: notifications notifications_update_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY notifications_update_own ON public.notifications FOR UPDATE USING ((auth.uid() = user_id)) WITH CHECK ((auth.uid() = user_id));


--
-- TOC entry 4938 (class 3256 OID 18770)
-- Name: site_terms_acceptance owner_insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY owner_insert ON public.site_terms_acceptance FOR INSERT WITH CHECK ((profile_id = auth.uid()));


--
-- TOC entry 4937 (class 3256 OID 18769)
-- Name: site_terms_acceptance owner_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY owner_select ON public.site_terms_acceptance FOR SELECT USING ((profile_id = auth.uid()));


--
-- TOC entry 4854 (class 0 OID 17919)
-- Dependencies: 379
-- Name: player_stats; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.player_stats ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4891 (class 3256 OID 18000)
-- Name: player_stats player_stats_all_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY player_stats_all_admin ON public.player_stats USING (public.is_admin(auth.uid()));


--
-- TOC entry 4890 (class 3256 OID 17999)
-- Name: player_stats player_stats_select_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY player_stats_select_all ON public.player_stats FOR SELECT USING (true);


--
-- TOC entry 4849 (class 0 OID 17740)
-- Dependencies: 374
-- Name: players; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.players ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4880 (class 3256 OID 17859)
-- Name: players players_delete_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY players_delete_admin ON public.players FOR DELETE USING (public.is_admin(auth.uid()));


--
-- TOC entry 4878 (class 3256 OID 17857)
-- Name: players players_insert_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY players_insert_admin ON public.players FOR INSERT WITH CHECK (public.is_admin(auth.uid()));


--
-- TOC entry 4877 (class 3256 OID 17856)
-- Name: players players_select_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY players_select_all ON public.players FOR SELECT USING (true);


--
-- TOC entry 4879 (class 3256 OID 17858)
-- Name: players players_update_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY players_update_admin ON public.players FOR UPDATE USING (public.is_admin(auth.uid()));


--
-- TOC entry 4959 (class 3256 OID 19902)
-- Name: players players_update_team_owner; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY players_update_team_owner ON public.players FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM public.teams
  WHERE ((teams.id = players.team_id) AND (teams.owner_id = auth.uid())))));


--
-- TOC entry 4897 (class 3256 OID 18289)
-- Name: prize_distribution prize_dist_delete_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY prize_dist_delete_admin ON public.prize_distribution FOR DELETE USING (public.is_admin(auth.uid()));


--
-- TOC entry 4895 (class 3256 OID 18287)
-- Name: prize_distribution prize_dist_insert_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY prize_dist_insert_admin ON public.prize_distribution FOR INSERT WITH CHECK (public.is_admin(auth.uid()));


--
-- TOC entry 4894 (class 3256 OID 18286)
-- Name: prize_distribution prize_dist_select_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY prize_dist_select_all ON public.prize_distribution FOR SELECT USING (true);


--
-- TOC entry 4896 (class 3256 OID 18288)
-- Name: prize_distribution prize_dist_update_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY prize_dist_update_admin ON public.prize_distribution FOR UPDATE USING (public.is_admin(auth.uid()));


--
-- TOC entry 4856 (class 0 OID 18106)
-- Dependencies: 381
-- Name: prize_distribution; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.prize_distribution ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4846 (class 0 OID 17681)
-- Dependencies: 371
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4935 (class 3256 OID 18626)
-- Name: profiles profiles_count_public; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY profiles_count_public ON public.profiles FOR SELECT USING (true);


--
-- TOC entry 4869 (class 3256 OID 17845)
-- Name: profiles profiles_select_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY profiles_select_all ON public.profiles FOR SELECT USING (true);


--
-- TOC entry 4923 (class 3256 OID 18729)
-- Name: profiles profiles_select_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY profiles_select_own ON public.profiles FOR SELECT USING ((auth.uid() = id));


--
-- TOC entry 4871 (class 3256 OID 17847)
-- Name: profiles profiles_update_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY profiles_update_admin ON public.profiles FOR UPDATE USING (public.is_admin(auth.uid()));


--
-- TOC entry 4870 (class 3256 OID 17846)
-- Name: profiles profiles_update_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY profiles_update_own ON public.profiles FOR UPDATE USING ((auth.uid() = id));


--
-- TOC entry 4863 (class 0 OID 18464)
-- Dependencies: 397
-- Name: rank_snapshots; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.rank_snapshots ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4925 (class 3256 OID 18510)
-- Name: rank_snapshots rank_snapshots_insert_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY rank_snapshots_insert_own ON public.rank_snapshots FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM public.riot_accounts ra
  WHERE ((ra.id = rank_snapshots.riot_account_id) AND (ra.profile_id = auth.uid())))));


--
-- TOC entry 4924 (class 3256 OID 18509)
-- Name: rank_snapshots rank_snapshots_select_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY rank_snapshots_select_own ON public.rank_snapshots FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.riot_accounts ra
  WHERE ((ra.id = rank_snapshots.riot_account_id) AND (ra.profile_id = auth.uid())))));


--
-- TOC entry 4862 (class 0 OID 18442)
-- Dependencies: 396
-- Name: riot_accounts; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.riot_accounts ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4936 (class 3256 OID 18631)
-- Name: riot_accounts riot_accounts_count_public; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY riot_accounts_count_public ON public.riot_accounts FOR SELECT USING (true);


--
-- TOC entry 4922 (class 3256 OID 18508)
-- Name: riot_accounts riot_accounts_delete_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY riot_accounts_delete_own ON public.riot_accounts FOR DELETE USING ((auth.uid() = profile_id));


--
-- TOC entry 4920 (class 3256 OID 18506)
-- Name: riot_accounts riot_accounts_insert_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY riot_accounts_insert_own ON public.riot_accounts FOR INSERT WITH CHECK ((auth.uid() = profile_id));


--
-- TOC entry 4919 (class 3256 OID 18505)
-- Name: riot_accounts riot_accounts_select_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY riot_accounts_select_own ON public.riot_accounts FOR SELECT USING ((auth.uid() = profile_id));


--
-- TOC entry 4921 (class 3256 OID 18507)
-- Name: riot_accounts riot_accounts_update_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY riot_accounts_update_own ON public.riot_accounts FOR UPDATE USING ((auth.uid() = profile_id)) WITH CHECK ((auth.uid() = profile_id));


--
-- TOC entry 4912 (class 3256 OID 18305)
-- Name: tournament_rules rules_delete_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY rules_delete_admin ON public.tournament_rules FOR DELETE USING (public.is_admin(auth.uid()));


--
-- TOC entry 4893 (class 3256 OID 18303)
-- Name: tournament_rules rules_insert_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY rules_insert_admin ON public.tournament_rules FOR INSERT WITH CHECK (public.is_admin(auth.uid()));


--
-- TOC entry 4910 (class 3256 OID 18302)
-- Name: tournament_rules rules_select_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY rules_select_all ON public.tournament_rules FOR SELECT USING (true);


--
-- TOC entry 4911 (class 3256 OID 18304)
-- Name: tournament_rules rules_update_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY rules_update_admin ON public.tournament_rules FOR UPDATE USING (public.is_admin(auth.uid()));


--
-- TOC entry 4857 (class 0 OID 18121)
-- Dependencies: 382
-- Name: seedings; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.seedings ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4901 (class 3256 OID 18293)
-- Name: seedings seedings_delete_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY seedings_delete_admin ON public.seedings FOR DELETE USING (public.is_admin(auth.uid()));


--
-- TOC entry 4899 (class 3256 OID 18291)
-- Name: seedings seedings_insert_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY seedings_insert_admin ON public.seedings FOR INSERT WITH CHECK (public.is_admin(auth.uid()));


--
-- TOC entry 4898 (class 3256 OID 18290)
-- Name: seedings seedings_select_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY seedings_select_all ON public.seedings FOR SELECT USING (true);


--
-- TOC entry 4900 (class 3256 OID 18292)
-- Name: seedings seedings_update_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY seedings_update_admin ON public.seedings FOR UPDATE USING (public.is_admin(auth.uid()));


--
-- TOC entry 4865 (class 0 OID 18751)
-- Dependencies: 404
-- Name: site_terms_acceptance; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.site_terms_acceptance ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4887 (class 3256 OID 17996)
-- Name: tournament_stages stages_all_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY stages_all_admin ON public.tournament_stages USING (public.is_admin(auth.uid()));


--
-- TOC entry 4886 (class 3256 OID 17995)
-- Name: tournament_stages stages_select_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY stages_select_all ON public.tournament_stages FOR SELECT USING (true);


--
-- TOC entry 4858 (class 0 OID 18157)
-- Dependencies: 383
-- Name: team_invites; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.team_invites ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4965 (class 3256 OID 19919)
-- Name: team_invites team_invites_delete; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY team_invites_delete ON public.team_invites FOR DELETE USING ((public.is_admin(auth.uid()) OR (team_id IN ( SELECT teams.id
   FROM public.teams
  WHERE (teams.owner_id = auth.uid())))));


--
-- TOC entry 4905 (class 3256 OID 18297)
-- Name: team_invites team_invites_delete_owner_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY team_invites_delete_owner_or_admin ON public.team_invites FOR DELETE USING ((public.is_admin(auth.uid()) OR (auth.uid() IN ( SELECT teams.owner_id
   FROM public.teams
  WHERE (teams.id = team_invites.team_id)))));


--
-- TOC entry 4963 (class 3256 OID 19917)
-- Name: team_invites team_invites_insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY team_invites_insert ON public.team_invites FOR INSERT WITH CHECK ((public.is_admin(auth.uid()) OR (team_id IN ( SELECT teams.id
   FROM public.teams
  WHERE (teams.owner_id = auth.uid())))));


--
-- TOC entry 4903 (class 3256 OID 18295)
-- Name: team_invites team_invites_insert_owner_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY team_invites_insert_owner_or_admin ON public.team_invites FOR INSERT WITH CHECK ((public.is_admin(auth.uid()) OR (auth.uid() IN ( SELECT teams.owner_id
   FROM public.teams
  WHERE (teams.id = team_invites.team_id)))));


--
-- TOC entry 4962 (class 3256 OID 19916)
-- Name: team_invites team_invites_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY team_invites_select ON public.team_invites FOR SELECT USING ((public.is_admin(auth.uid()) OR (team_id IN ( SELECT teams.id
   FROM public.teams
  WHERE (teams.owner_id = auth.uid()))) OR (invited_by = auth.uid())));


--
-- TOC entry 4902 (class 3256 OID 18294)
-- Name: team_invites team_invites_select_owner_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY team_invites_select_owner_or_admin ON public.team_invites FOR SELECT USING ((public.is_admin(auth.uid()) OR (auth.uid() IN ( SELECT teams.owner_id
   FROM public.teams
  WHERE (teams.id = team_invites.team_id)))));


--
-- TOC entry 4964 (class 3256 OID 19918)
-- Name: team_invites team_invites_update; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY team_invites_update ON public.team_invites FOR UPDATE USING ((public.is_admin(auth.uid()) OR (team_id IN ( SELECT teams.id
   FROM public.teams
  WHERE (teams.owner_id = auth.uid())))));


--
-- TOC entry 4904 (class 3256 OID 18296)
-- Name: team_invites team_invites_update_owner_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY team_invites_update_owner_or_admin ON public.team_invites FOR UPDATE USING ((public.is_admin(auth.uid()) OR (auth.uid() IN ( SELECT teams.owner_id
   FROM public.teams
  WHERE (teams.id = team_invites.team_id)))));


--
-- TOC entry 4866 (class 0 OID 19831)
-- Dependencies: 406
-- Name: team_members; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.team_members ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4946 (class 3256 OID 19884)
-- Name: team_members team_members_delete; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY team_members_delete ON public.team_members FOR DELETE USING ((public.is_admin(auth.uid()) OR (team_id IN ( SELECT teams.id
   FROM public.teams
  WHERE (teams.owner_id = auth.uid()))) OR (profile_id = auth.uid())));


--
-- TOC entry 4943 (class 3256 OID 19882)
-- Name: team_members team_members_insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY team_members_insert ON public.team_members FOR INSERT WITH CHECK ((public.is_admin(auth.uid()) OR (team_id IN ( SELECT teams.id
   FROM public.teams
  WHERE (teams.owner_id = auth.uid())))));


--
-- TOC entry 4942 (class 3256 OID 19881)
-- Name: team_members team_members_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY team_members_select ON public.team_members FOR SELECT USING (((auth.role() = 'authenticated'::text) AND (public.is_admin(auth.uid()) OR (profile_id = auth.uid()) OR (team_id IN ( SELECT teams.id
   FROM public.teams
  WHERE (teams.owner_id = auth.uid()))) OR (team_id IN ( SELECT team_members_1.team_id
   FROM public.team_members team_members_1
  WHERE ((team_members_1.profile_id = auth.uid()) AND (team_members_1.status = 'accepted'::public.team_member_status)))))));


--
-- TOC entry 4944 (class 3256 OID 19883)
-- Name: team_members team_members_update; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY team_members_update ON public.team_members FOR UPDATE USING ((public.is_admin(auth.uid()) OR (team_id IN ( SELECT teams.id
   FROM public.teams
  WHERE (teams.owner_id = auth.uid()))) OR ((profile_id = auth.uid()) AND (status = 'pending'::public.team_member_status))));


--
-- TOC entry 4848 (class 0 OID 17718)
-- Dependencies: 373
-- Name: teams; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.teams ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4876 (class 3256 OID 17855)
-- Name: teams teams_delete_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY teams_delete_admin ON public.teams FOR DELETE USING (public.is_admin(auth.uid()));


--
-- TOC entry 4956 (class 3256 OID 19897)
-- Name: teams teams_delete_owner; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY teams_delete_owner ON public.teams FOR DELETE USING ((auth.uid() = owner_id));


--
-- TOC entry 4939 (class 3256 OID 19898)
-- Name: teams teams_insert_authenticated; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY teams_insert_authenticated ON public.teams FOR INSERT WITH CHECK ((auth.uid() = owner_id));


--
-- TOC entry 4874 (class 3256 OID 17853)
-- Name: teams teams_insert_owner_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY teams_insert_owner_or_admin ON public.teams FOR INSERT WITH CHECK (((auth.uid() = owner_id) OR public.is_admin(auth.uid())));


--
-- TOC entry 4873 (class 3256 OID 17852)
-- Name: teams teams_select_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY teams_select_all ON public.teams FOR SELECT USING (true);


--
-- TOC entry 4955 (class 3256 OID 19896)
-- Name: teams teams_update_owner; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY teams_update_owner ON public.teams FOR UPDATE USING ((auth.uid() = owner_id));


--
-- TOC entry 4875 (class 3256 OID 17854)
-- Name: teams teams_update_owner_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY teams_update_owner_or_admin ON public.teams FOR UPDATE USING (((auth.uid() = owner_id) OR public.is_admin(auth.uid())));


--
-- TOC entry 4950 (class 3256 OID 19888)
-- Name: site_terms_acceptance terms_insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY terms_insert ON public.site_terms_acceptance FOR INSERT WITH CHECK ((profile_id = auth.uid()));


--
-- TOC entry 4949 (class 3256 OID 19887)
-- Name: site_terms_acceptance terms_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY terms_select ON public.site_terms_acceptance FOR SELECT USING ((profile_id = auth.uid()));


--
-- TOC entry 4868 (class 0 OID 19923)
-- Dependencies: 408
-- Name: tournament_match_results; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.tournament_match_results ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4860 (class 0 OID 18215)
-- Dependencies: 385
-- Name: tournament_rules; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.tournament_rules ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4852 (class 0 OID 17867)
-- Dependencies: 377
-- Name: tournament_stages; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.tournament_stages ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4847 (class 0 OID 17699)
-- Dependencies: 372
-- Name: tournaments; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.tournaments ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4953 (class 3256 OID 19891)
-- Name: tournaments tournaments_delete_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY tournaments_delete_admin ON public.tournaments FOR DELETE USING (public.is_admin(auth.uid()));


--
-- TOC entry 4941 (class 3256 OID 18780)
-- Name: tournaments tournaments_insert_organizer; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY tournaments_insert_organizer ON public.tournaments FOR INSERT TO authenticated WITH CHECK (((organizer_id = auth.uid()) AND (created_by = auth.uid()) AND (NOT (EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.id = auth.uid()) AND (profiles.is_banned = true)))))));


--
-- TOC entry 4951 (class 3256 OID 19889)
-- Name: tournaments tournaments_insert_organizer_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY tournaments_insert_organizer_or_admin ON public.tournaments FOR INSERT WITH CHECK (public.is_organizer_or_admin(auth.uid()));


--
-- TOC entry 4872 (class 3256 OID 17848)
-- Name: tournaments tournaments_select_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY tournaments_select_all ON public.tournaments FOR SELECT USING (true);


--
-- TOC entry 4952 (class 3256 OID 19890)
-- Name: tournaments tournaments_update_organizer_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY tournaments_update_organizer_or_admin ON public.tournaments FOR UPDATE USING ((public.is_admin(auth.uid()) OR ((auth.uid() = organizer_id) AND public.is_organizer_or_admin(auth.uid()))));


--
-- TOC entry 4917 (class 3256 OID 18434)
-- Name: notifications users_see_own_notifications; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY users_see_own_notifications ON public.notifications FOR SELECT USING ((auth.uid() = user_id));


--
-- TOC entry 4918 (class 3256 OID 18435)
-- Name: notifications users_update_own_notifications; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY users_update_own_notifications ON public.notifications FOR UPDATE USING ((auth.uid() = user_id));


--
-- TOC entry 4845 (class 0 OID 17529)
-- Dependencies: 370
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4838 (class 0 OID 17176)
-- Dependencies: 357
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4842 (class 0 OID 17296)
-- Dependencies: 361
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4843 (class 0 OID 17309)
-- Dependencies: 362
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4837 (class 0 OID 17168)
-- Dependencies: 356
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4839 (class 0 OID 17186)
-- Dependencies: 358
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4840 (class 0 OID 17235)
-- Dependencies: 359
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4841 (class 0 OID 17249)
-- Dependencies: 360
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4844 (class 0 OID 17319)
-- Dependencies: 363
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4975 (class 0 OID 0)
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
-- TOC entry 4977 (class 0 OID 0)
-- Dependencies: 17
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- TOC entry 4978 (class 0 OID 0)
-- Dependencies: 16
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- TOC entry 4979 (class 0 OID 0)
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
-- TOC entry 4980 (class 0 OID 0)
-- Dependencies: 34
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA vault TO service_role;


--
-- TOC entry 4982 (class 0 OID 0)
-- Dependencies: 578
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- TOC entry 4983 (class 0 OID 0)
-- Dependencies: 563
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- TOC entry 4985 (class 0 OID 0)
-- Dependencies: 577
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- TOC entry 4987 (class 0 OID 0)
-- Dependencies: 582
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- TOC entry 4988 (class 0 OID 0)
-- Dependencies: 445
-- Name: FUNCTION accept_team_invite(p_invite_id uuid, p_profile_id uuid, p_riot_acc_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.accept_team_invite(p_invite_id uuid, p_profile_id uuid, p_riot_acc_id uuid) TO anon;
GRANT ALL ON FUNCTION public.accept_team_invite(p_invite_id uuid, p_profile_id uuid, p_riot_acc_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.accept_team_invite(p_invite_id uuid, p_profile_id uuid, p_riot_acc_id uuid) TO service_role;


--
-- TOC entry 4989 (class 0 OID 0)
-- Dependencies: 575
-- Name: FUNCTION audit_matches_changes(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.audit_matches_changes() TO anon;
GRANT ALL ON FUNCTION public.audit_matches_changes() TO authenticated;
GRANT ALL ON FUNCTION public.audit_matches_changes() TO service_role;


--
-- TOC entry 4990 (class 0 OID 0)
-- Dependencies: 545
-- Name: FUNCTION auto_add_captain_as_member(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.auto_add_captain_as_member() TO anon;
GRANT ALL ON FUNCTION public.auto_add_captain_as_member() TO authenticated;
GRANT ALL ON FUNCTION public.auto_add_captain_as_member() TO service_role;


--
-- TOC entry 4991 (class 0 OID 0)
-- Dependencies: 501
-- Name: FUNCTION call_edge_function(function_name text, payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.call_edge_function(function_name text, payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.call_edge_function(function_name text, payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.call_edge_function(function_name text, payload jsonb) TO service_role;


--
-- TOC entry 4992 (class 0 OID 0)
-- Dependencies: 515
-- Name: FUNCTION ensure_single_primary_riot_account(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ensure_single_primary_riot_account() TO anon;
GRANT ALL ON FUNCTION public.ensure_single_primary_riot_account() TO authenticated;
GRANT ALL ON FUNCTION public.ensure_single_primary_riot_account() TO service_role;


--
-- TOC entry 4993 (class 0 OID 0)
-- Dependencies: 581
-- Name: FUNCTION expire_pending_invites(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.expire_pending_invites() TO anon;
GRANT ALL ON FUNCTION public.expire_pending_invites() TO authenticated;
GRANT ALL ON FUNCTION public.expire_pending_invites() TO service_role;


--
-- TOC entry 4994 (class 0 OID 0)
-- Dependencies: 532
-- Name: FUNCTION fn_notify_inscricao(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_notify_inscricao() TO anon;
GRANT ALL ON FUNCTION public.fn_notify_inscricao() TO authenticated;
GRANT ALL ON FUNCTION public.fn_notify_inscricao() TO service_role;


--
-- TOC entry 4995 (class 0 OID 0)
-- Dependencies: 495
-- Name: FUNCTION generate_tournament_slug(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.generate_tournament_slug() TO anon;
GRANT ALL ON FUNCTION public.generate_tournament_slug() TO authenticated;
GRANT ALL ON FUNCTION public.generate_tournament_slug() TO service_role;


--
-- TOC entry 4996 (class 0 OID 0)
-- Dependencies: 543
-- Name: FUNCTION handle_new_user(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.handle_new_user() TO anon;
GRANT ALL ON FUNCTION public.handle_new_user() TO authenticated;
GRANT ALL ON FUNCTION public.handle_new_user() TO service_role;


--
-- TOC entry 4997 (class 0 OID 0)
-- Dependencies: 490
-- Name: FUNCTION has_call_edge_function(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.has_call_edge_function() TO anon;
GRANT ALL ON FUNCTION public.has_call_edge_function() TO authenticated;
GRANT ALL ON FUNCTION public.has_call_edge_function() TO service_role;


--
-- TOC entry 4998 (class 0 OID 0)
-- Dependencies: 506
-- Name: FUNCTION is_admin(uid uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.is_admin(uid uuid) TO anon;
GRANT ALL ON FUNCTION public.is_admin(uid uuid) TO authenticated;
GRANT ALL ON FUNCTION public.is_admin(uid uuid) TO service_role;


--
-- TOC entry 4999 (class 0 OID 0)
-- Dependencies: 473
-- Name: FUNCTION is_current_user_admin(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.is_current_user_admin() TO anon;
GRANT ALL ON FUNCTION public.is_current_user_admin() TO authenticated;
GRANT ALL ON FUNCTION public.is_current_user_admin() TO service_role;


--
-- TOC entry 5000 (class 0 OID 0)
-- Dependencies: 460
-- Name: FUNCTION is_organizer_or_admin(uid uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.is_organizer_or_admin(uid uuid) TO anon;
GRANT ALL ON FUNCTION public.is_organizer_or_admin(uid uuid) TO authenticated;
GRANT ALL ON FUNCTION public.is_organizer_or_admin(uid uuid) TO service_role;


--
-- TOC entry 5001 (class 0 OID 0)
-- Dependencies: 412
-- Name: FUNCTION is_tournament_organizer(uid uuid, tid uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.is_tournament_organizer(uid uuid, tid uuid) TO anon;
GRANT ALL ON FUNCTION public.is_tournament_organizer(uid uuid, tid uuid) TO authenticated;
GRANT ALL ON FUNCTION public.is_tournament_organizer(uid uuid, tid uuid) TO service_role;


--
-- TOC entry 5002 (class 0 OID 0)
-- Dependencies: 584
-- Name: FUNCTION log_admin_action(p_action text, p_table_name text, p_record_id text, p_old_data jsonb, p_new_data jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.log_admin_action(p_action text, p_table_name text, p_record_id text, p_old_data jsonb, p_new_data jsonb) TO anon;
GRANT ALL ON FUNCTION public.log_admin_action(p_action text, p_table_name text, p_record_id text, p_old_data jsonb, p_new_data jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.log_admin_action(p_action text, p_table_name text, p_record_id text, p_old_data jsonb, p_new_data jsonb) TO service_role;


--
-- TOC entry 5003 (class 0 OID 0)
-- Dependencies: 446
-- Name: FUNCTION set_updated_at(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.set_updated_at() TO anon;
GRANT ALL ON FUNCTION public.set_updated_at() TO authenticated;
GRANT ALL ON FUNCTION public.set_updated_at() TO service_role;


--
-- TOC entry 5004 (class 0 OID 0)
-- Dependencies: 485
-- Name: FUNCTION sync_notifications_body_message(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.sync_notifications_body_message() TO anon;
GRANT ALL ON FUNCTION public.sync_notifications_body_message() TO authenticated;
GRANT ALL ON FUNCTION public.sync_notifications_body_message() TO service_role;


--
-- TOC entry 5005 (class 0 OID 0)
-- Dependencies: 511
-- Name: FUNCTION trg_inscricao_nova(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.trg_inscricao_nova() TO anon;
GRANT ALL ON FUNCTION public.trg_inscricao_nova() TO authenticated;
GRANT ALL ON FUNCTION public.trg_inscricao_nova() TO service_role;


--
-- TOC entry 5006 (class 0 OID 0)
-- Dependencies: 571
-- Name: FUNCTION trg_inscricao_status_change(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.trg_inscricao_status_change() TO anon;
GRANT ALL ON FUNCTION public.trg_inscricao_status_change() TO authenticated;
GRANT ALL ON FUNCTION public.trg_inscricao_status_change() TO service_role;


--
-- TOC entry 5007 (class 0 OID 0)
-- Dependencies: 422
-- Name: FUNCTION trg_match_finished(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.trg_match_finished() TO anon;
GRANT ALL ON FUNCTION public.trg_match_finished() TO authenticated;
GRANT ALL ON FUNCTION public.trg_match_finished() TO service_role;


--
-- TOC entry 5008 (class 0 OID 0)
-- Dependencies: 449
-- Name: FUNCTION trg_tournament_started(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.trg_tournament_started() TO anon;
GRANT ALL ON FUNCTION public.trg_tournament_started() TO authenticated;
GRANT ALL ON FUNCTION public.trg_tournament_started() TO service_role;


--
-- TOC entry 5009 (class 0 OID 0)
-- Dependencies: 551
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO supabase_realtime_admin;


--
-- TOC entry 5010 (class 0 OID 0)
-- Dependencies: 418
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- TOC entry 5011 (class 0 OID 0)
-- Dependencies: 546
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO supabase_realtime_admin;


--
-- TOC entry 5012 (class 0 OID 0)
-- Dependencies: 482
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO supabase_realtime_admin;


--
-- TOC entry 5013 (class 0 OID 0)
-- Dependencies: 415
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO supabase_realtime_admin;


--
-- TOC entry 5014 (class 0 OID 0)
-- Dependencies: 512
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO supabase_realtime_admin;


--
-- TOC entry 5015 (class 0 OID 0)
-- Dependencies: 481
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;


--
-- TOC entry 5016 (class 0 OID 0)
-- Dependencies: 480
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO supabase_realtime_admin;


--
-- TOC entry 5017 (class 0 OID 0)
-- Dependencies: 410
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- TOC entry 5018 (class 0 OID 0)
-- Dependencies: 444
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO supabase_realtime_admin;


--
-- TOC entry 5019 (class 0 OID 0)
-- Dependencies: 528
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO supabase_realtime_admin;


--
-- TOC entry 5020 (class 0 OID 0)
-- Dependencies: 542
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- TOC entry 5022 (class 0 OID 0)
-- Dependencies: 334
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- TOC entry 5023 (class 0 OID 0)
-- Dependencies: 353
-- Name: TABLE custom_oauth_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.custom_oauth_providers TO postgres;
GRANT ALL ON TABLE auth.custom_oauth_providers TO dashboard_user;


--
-- TOC entry 5025 (class 0 OID 0)
-- Dependencies: 347
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- TOC entry 5028 (class 0 OID 0)
-- Dependencies: 338
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- TOC entry 5030 (class 0 OID 0)
-- Dependencies: 333
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- TOC entry 5032 (class 0 OID 0)
-- Dependencies: 342
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- TOC entry 5034 (class 0 OID 0)
-- Dependencies: 341
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- TOC entry 5037 (class 0 OID 0)
-- Dependencies: 340
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- TOC entry 5038 (class 0 OID 0)
-- Dependencies: 350
-- Name: TABLE oauth_authorizations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_authorizations TO postgres;
GRANT ALL ON TABLE auth.oauth_authorizations TO dashboard_user;


--
-- TOC entry 5040 (class 0 OID 0)
-- Dependencies: 352
-- Name: TABLE oauth_client_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_client_states TO postgres;
GRANT ALL ON TABLE auth.oauth_client_states TO dashboard_user;


--
-- TOC entry 5041 (class 0 OID 0)
-- Dependencies: 349
-- Name: TABLE oauth_clients; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_clients TO postgres;
GRANT ALL ON TABLE auth.oauth_clients TO dashboard_user;


--
-- TOC entry 5042 (class 0 OID 0)
-- Dependencies: 351
-- Name: TABLE oauth_consents; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_consents TO postgres;
GRANT ALL ON TABLE auth.oauth_consents TO dashboard_user;


--
-- TOC entry 5043 (class 0 OID 0)
-- Dependencies: 348
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- TOC entry 5045 (class 0 OID 0)
-- Dependencies: 332
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- TOC entry 5047 (class 0 OID 0)
-- Dependencies: 331
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- TOC entry 5049 (class 0 OID 0)
-- Dependencies: 345
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- TOC entry 5051 (class 0 OID 0)
-- Dependencies: 346
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- TOC entry 5053 (class 0 OID 0)
-- Dependencies: 335
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


--
-- TOC entry 5058 (class 0 OID 0)
-- Dependencies: 339
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- TOC entry 5060 (class 0 OID 0)
-- Dependencies: 344
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- TOC entry 5063 (class 0 OID 0)
-- Dependencies: 343
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- TOC entry 5066 (class 0 OID 0)
-- Dependencies: 330
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- TOC entry 5067 (class 0 OID 0)
-- Dependencies: 355
-- Name: TABLE webauthn_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_challenges TO postgres;
GRANT ALL ON TABLE auth.webauthn_challenges TO dashboard_user;


--
-- TOC entry 5068 (class 0 OID 0)
-- Dependencies: 354
-- Name: TABLE webauthn_credentials; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_credentials TO postgres;
GRANT ALL ON TABLE auth.webauthn_credentials TO dashboard_user;


--
-- TOC entry 5069 (class 0 OID 0)
-- Dependencies: 407
-- Name: TABLE active_team; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.active_team TO anon;
GRANT ALL ON TABLE public.active_team TO authenticated;
GRANT ALL ON TABLE public.active_team TO service_role;


--
-- TOC entry 5070 (class 0 OID 0)
-- Dependencies: 386
-- Name: TABLE audit_log; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.audit_log TO anon;
GRANT ALL ON TABLE public.audit_log TO authenticated;
GRANT ALL ON TABLE public.audit_log TO service_role;


--
-- TOC entry 5071 (class 0 OID 0)
-- Dependencies: 398
-- Name: TABLE champion_masteries; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.champion_masteries TO anon;
GRANT ALL ON TABLE public.champion_masteries TO authenticated;
GRANT ALL ON TABLE public.champion_masteries TO service_role;


--
-- TOC entry 5072 (class 0 OID 0)
-- Dependencies: 384
-- Name: TABLE disputes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.disputes TO anon;
GRANT ALL ON TABLE public.disputes TO authenticated;
GRANT ALL ON TABLE public.disputes TO service_role;


--
-- TOC entry 5076 (class 0 OID 0)
-- Dependencies: 375
-- Name: TABLE inscricoes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.inscricoes TO anon;
GRANT ALL ON TABLE public.inscricoes TO authenticated;
GRANT ALL ON TABLE public.inscricoes TO service_role;


--
-- TOC entry 5077 (class 0 OID 0)
-- Dependencies: 378
-- Name: TABLE match_games; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.match_games TO anon;
GRANT ALL ON TABLE public.match_games TO authenticated;
GRANT ALL ON TABLE public.match_games TO service_role;


--
-- TOC entry 5078 (class 0 OID 0)
-- Dependencies: 376
-- Name: TABLE matches; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.matches TO anon;
GRANT ALL ON TABLE public.matches TO authenticated;
GRANT ALL ON TABLE public.matches TO service_role;


--
-- TOC entry 5079 (class 0 OID 0)
-- Dependencies: 380
-- Name: TABLE notifications; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.notifications TO anon;
GRANT ALL ON TABLE public.notifications TO authenticated;
GRANT ALL ON TABLE public.notifications TO service_role;


--
-- TOC entry 5080 (class 0 OID 0)
-- Dependencies: 379
-- Name: TABLE player_stats; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.player_stats TO anon;
GRANT ALL ON TABLE public.player_stats TO authenticated;
GRANT ALL ON TABLE public.player_stats TO service_role;


--
-- TOC entry 5081 (class 0 OID 0)
-- Dependencies: 374
-- Name: TABLE players; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.players TO anon;
GRANT ALL ON TABLE public.players TO authenticated;
GRANT ALL ON TABLE public.players TO service_role;


--
-- TOC entry 5082 (class 0 OID 0)
-- Dependencies: 381
-- Name: TABLE prize_distribution; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.prize_distribution TO anon;
GRANT ALL ON TABLE public.prize_distribution TO authenticated;
GRANT ALL ON TABLE public.prize_distribution TO service_role;


--
-- TOC entry 5083 (class 0 OID 0)
-- Dependencies: 371
-- Name: TABLE profiles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.profiles TO anon;
GRANT ALL ON TABLE public.profiles TO authenticated;
GRANT ALL ON TABLE public.profiles TO service_role;


--
-- TOC entry 5084 (class 0 OID 0)
-- Dependencies: 397
-- Name: TABLE rank_snapshots; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.rank_snapshots TO anon;
GRANT ALL ON TABLE public.rank_snapshots TO authenticated;
GRANT ALL ON TABLE public.rank_snapshots TO service_role;


--
-- TOC entry 5085 (class 0 OID 0)
-- Dependencies: 396
-- Name: TABLE riot_accounts; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.riot_accounts TO anon;
GRANT ALL ON TABLE public.riot_accounts TO authenticated;
GRANT ALL ON TABLE public.riot_accounts TO service_role;


--
-- TOC entry 5086 (class 0 OID 0)
-- Dependencies: 382
-- Name: TABLE seedings; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.seedings TO anon;
GRANT ALL ON TABLE public.seedings TO authenticated;
GRANT ALL ON TABLE public.seedings TO service_role;


--
-- TOC entry 5088 (class 0 OID 0)
-- Dependencies: 404
-- Name: TABLE site_terms_acceptance; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.site_terms_acceptance TO anon;
GRANT ALL ON TABLE public.site_terms_acceptance TO authenticated;
GRANT ALL ON TABLE public.site_terms_acceptance TO service_role;


--
-- TOC entry 5089 (class 0 OID 0)
-- Dependencies: 383
-- Name: TABLE team_invites; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.team_invites TO anon;
GRANT ALL ON TABLE public.team_invites TO authenticated;
GRANT ALL ON TABLE public.team_invites TO service_role;


--
-- TOC entry 5090 (class 0 OID 0)
-- Dependencies: 406
-- Name: TABLE team_members; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.team_members TO anon;
GRANT ALL ON TABLE public.team_members TO authenticated;
GRANT ALL ON TABLE public.team_members TO service_role;


--
-- TOC entry 5091 (class 0 OID 0)
-- Dependencies: 373
-- Name: TABLE teams; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.teams TO anon;
GRANT ALL ON TABLE public.teams TO authenticated;
GRANT ALL ON TABLE public.teams TO service_role;


--
-- TOC entry 5092 (class 0 OID 0)
-- Dependencies: 408
-- Name: TABLE tournament_match_results; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tournament_match_results TO anon;
GRANT ALL ON TABLE public.tournament_match_results TO authenticated;
GRANT ALL ON TABLE public.tournament_match_results TO service_role;


--
-- TOC entry 5093 (class 0 OID 0)
-- Dependencies: 385
-- Name: TABLE tournament_rules; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tournament_rules TO anon;
GRANT ALL ON TABLE public.tournament_rules TO authenticated;
GRANT ALL ON TABLE public.tournament_rules TO service_role;


--
-- TOC entry 5094 (class 0 OID 0)
-- Dependencies: 377
-- Name: TABLE tournament_stages; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tournament_stages TO anon;
GRANT ALL ON TABLE public.tournament_stages TO authenticated;
GRANT ALL ON TABLE public.tournament_stages TO service_role;


--
-- TOC entry 5097 (class 0 OID 0)
-- Dependencies: 372
-- Name: TABLE tournaments; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tournaments TO anon;
GRANT ALL ON TABLE public.tournaments TO authenticated;
GRANT ALL ON TABLE public.tournaments TO service_role;


--
-- TOC entry 5098 (class 0 OID 0)
-- Dependencies: 370
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- TOC entry 5099 (class 0 OID 0)
-- Dependencies: 399
-- Name: TABLE messages_2026_04_24; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_04_24 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_04_24 TO dashboard_user;


--
-- TOC entry 5100 (class 0 OID 0)
-- Dependencies: 400
-- Name: TABLE messages_2026_04_25; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_04_25 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_04_25 TO dashboard_user;


--
-- TOC entry 5101 (class 0 OID 0)
-- Dependencies: 401
-- Name: TABLE messages_2026_04_26; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_04_26 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_04_26 TO dashboard_user;


--
-- TOC entry 5102 (class 0 OID 0)
-- Dependencies: 402
-- Name: TABLE messages_2026_04_27; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_04_27 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_04_27 TO dashboard_user;


--
-- TOC entry 5103 (class 0 OID 0)
-- Dependencies: 403
-- Name: TABLE messages_2026_04_28; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_04_28 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_04_28 TO dashboard_user;


--
-- TOC entry 5104 (class 0 OID 0)
-- Dependencies: 405
-- Name: TABLE messages_2026_04_29; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_04_29 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_04_29 TO dashboard_user;


--
-- TOC entry 5105 (class 0 OID 0)
-- Dependencies: 409
-- Name: TABLE messages_2026_04_30; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_04_30 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_04_30 TO dashboard_user;


--
-- TOC entry 5106 (class 0 OID 0)
-- Dependencies: 364
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;
GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;
GRANT SELECT ON TABLE realtime.schema_migrations TO anon;
GRANT SELECT ON TABLE realtime.schema_migrations TO authenticated;
GRANT SELECT ON TABLE realtime.schema_migrations TO service_role;
GRANT ALL ON TABLE realtime.schema_migrations TO supabase_realtime_admin;


--
-- TOC entry 5107 (class 0 OID 0)
-- Dependencies: 367
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;
GRANT ALL ON TABLE realtime.subscription TO supabase_realtime_admin;


--
-- TOC entry 5108 (class 0 OID 0)
-- Dependencies: 366
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO supabase_realtime_admin;


--
-- TOC entry 5110 (class 0 OID 0)
-- Dependencies: 357
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.buckets FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.buckets TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO postgres WITH GRANT OPTION;


--
-- TOC entry 5111 (class 0 OID 0)
-- Dependencies: 361
-- Name: TABLE buckets_analytics; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets_analytics TO service_role;
GRANT ALL ON TABLE storage.buckets_analytics TO authenticated;
GRANT ALL ON TABLE storage.buckets_analytics TO anon;


--
-- TOC entry 5112 (class 0 OID 0)
-- Dependencies: 362
-- Name: TABLE buckets_vectors; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.buckets_vectors TO service_role;
GRANT SELECT ON TABLE storage.buckets_vectors TO authenticated;
GRANT SELECT ON TABLE storage.buckets_vectors TO anon;


--
-- TOC entry 5114 (class 0 OID 0)
-- Dependencies: 358
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.objects FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.objects TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO postgres WITH GRANT OPTION;


--
-- TOC entry 5115 (class 0 OID 0)
-- Dependencies: 359
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;


--
-- TOC entry 5116 (class 0 OID 0)
-- Dependencies: 360
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;


--
-- TOC entry 5117 (class 0 OID 0)
-- Dependencies: 363
-- Name: TABLE vector_indexes; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.vector_indexes TO service_role;
GRANT SELECT ON TABLE storage.vector_indexes TO authenticated;
GRANT SELECT ON TABLE storage.vector_indexes TO anon;


--
-- TOC entry 2723 (class 826 OID 16557)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- TOC entry 2724 (class 826 OID 16558)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- TOC entry 2722 (class 826 OID 16556)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO dashboard_user;


--
-- TOC entry 2715 (class 826 OID 16494)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- TOC entry 2716 (class 826 OID 16495)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- TOC entry 2714 (class 826 OID 16493)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- TOC entry 2718 (class 826 OID 16497)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- TOC entry 2713 (class 826 OID 16492)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- TOC entry 2717 (class 826 OID 16496)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- TOC entry 2726 (class 826 OID 16561)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- TOC entry 2727 (class 826 OID 16562)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- TOC entry 2725 (class 826 OID 16560)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO dashboard_user;


--
-- TOC entry 2721 (class 826 OID 16550)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- TOC entry 2720 (class 826 OID 16549)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- TOC entry 2719 (class 826 OID 16548)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;


-- Completed on 2026-04-27 16:46:59

--
-- PostgreSQL database dump complete
--

\unrestrict akGE1aM2oSLKPARZLS4oRUnZVca3CKWmVEEHgeWV1RFEEJROwkBNaMpWEAyNMTK