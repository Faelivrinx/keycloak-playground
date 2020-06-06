-- Adminer 4.7.7 PostgreSQL dump

CREATE TABLE "public"."admin_event_entity" (
    "id" character varying(36) NOT NULL,
    "admin_event_time" bigint,
    "realm_id" character varying(255),
    "operation_type" character varying(255),
    "auth_realm_id" character varying(255),
    "auth_client_id" character varying(255),
    "auth_user_id" character varying(255),
    "ip_address" character varying(255),
    "resource_path" character varying(2550),
    "representation" text,
    "error" character varying(255),
    "resource_type" character varying(64),
    CONSTRAINT "constraint_admin_event_entity" PRIMARY KEY ("id")
) WITH (oids = false);


CREATE TABLE "public"."associated_policy" (
    "policy_id" character varying(36) NOT NULL,
    "associated_policy_id" character varying(36) NOT NULL,
    CONSTRAINT "constraint_farsrpap" PRIMARY KEY ("policy_id", "associated_policy_id"),
    CONSTRAINT "fk_frsr5s213xcx4wnkog82ssrfy" FOREIGN KEY (associated_policy_id) REFERENCES resource_server_policy(id) NOT DEFERRABLE,
    CONSTRAINT "fk_frsrpas14xcx4wnkog82ssrfy" FOREIGN KEY (policy_id) REFERENCES resource_server_policy(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_assoc_pol_assoc_pol_id" ON "public"."associated_policy" USING btree ("associated_policy_id");


CREATE TABLE "public"."authentication_execution" (
    "id" character varying(36) NOT NULL,
    "alias" character varying(255),
    "authenticator" character varying(36),
    "realm_id" character varying(36),
    "flow_id" character varying(36),
    "requirement" integer,
    "priority" integer,
    "authenticator_flow" boolean DEFAULT false NOT NULL,
    "auth_flow_id" character varying(36),
    "auth_config" character varying(36),
    CONSTRAINT "constraint_auth_exec_pk" PRIMARY KEY ("id"),
    CONSTRAINT "fk_auth_exec_flow" FOREIGN KEY (flow_id) REFERENCES authentication_flow(id) NOT DEFERRABLE,
    CONSTRAINT "fk_auth_exec_realm" FOREIGN KEY (realm_id) REFERENCES realm(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_auth_exec_flow" ON "public"."authentication_execution" USING btree ("flow_id");

CREATE INDEX "idx_auth_exec_realm_flow" ON "public"."authentication_execution" USING btree ("realm_id", "flow_id");


CREATE TABLE "public"."authentication_flow" (
    "id" character varying(36) NOT NULL,
    "alias" character varying(255),
    "description" character varying(255),
    "realm_id" character varying(36),
    "provider_id" character varying(36) DEFAULT 'basic-flow' NOT NULL,
    "top_level" boolean DEFAULT false NOT NULL,
    "built_in" boolean DEFAULT false NOT NULL,
    CONSTRAINT "constraint_auth_flow_pk" PRIMARY KEY ("id"),
    CONSTRAINT "fk_auth_flow_realm" FOREIGN KEY (realm_id) REFERENCES realm(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_auth_flow_realm" ON "public"."authentication_flow" USING btree ("realm_id");


CREATE TABLE "public"."authenticator_config" (
    "id" character varying(36) NOT NULL,
    "alias" character varying(255),
    "realm_id" character varying(36),
    CONSTRAINT "constraint_auth_pk" PRIMARY KEY ("id"),
    CONSTRAINT "fk_auth_realm" FOREIGN KEY (realm_id) REFERENCES realm(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_auth_config_realm" ON "public"."authenticator_config" USING btree ("realm_id");


CREATE TABLE "public"."authenticator_config_entry" (
    "authenticator_id" character varying(36) NOT NULL,
    "value" text,
    "name" character varying(255) NOT NULL,
    CONSTRAINT "constraint_auth_cfg_pk" PRIMARY KEY ("authenticator_id", "name")
) WITH (oids = false);


CREATE TABLE "public"."broker_link" (
    "identity_provider" character varying(255) NOT NULL,
    "storage_provider_id" character varying(255),
    "realm_id" character varying(36) NOT NULL,
    "broker_user_id" character varying(255),
    "broker_username" character varying(255),
    "token" text,
    "user_id" character varying(255) NOT NULL,
    CONSTRAINT "constr_broker_link_pk" PRIMARY KEY ("identity_provider", "user_id")
) WITH (oids = false);


CREATE TABLE "public"."client" (
    "id" character varying(36) NOT NULL,
    "enabled" boolean DEFAULT false NOT NULL,
    "full_scope_allowed" boolean DEFAULT false NOT NULL,
    "client_id" character varying(255),
    "not_before" integer,
    "public_client" boolean DEFAULT false NOT NULL,
    "secret" character varying(255),
    "base_url" character varying(255),
    "bearer_only" boolean DEFAULT false NOT NULL,
    "management_url" character varying(255),
    "surrogate_auth_required" boolean DEFAULT false NOT NULL,
    "realm_id" character varying(36),
    "protocol" character varying(255),
    "node_rereg_timeout" integer DEFAULT '0',
    "frontchannel_logout" boolean DEFAULT false NOT NULL,
    "consent_required" boolean DEFAULT false NOT NULL,
    "name" character varying(255),
    "service_accounts_enabled" boolean DEFAULT false NOT NULL,
    "client_authenticator_type" character varying(255),
    "root_url" character varying(255),
    "description" character varying(255),
    "registration_token" character varying(255),
    "standard_flow_enabled" boolean DEFAULT true NOT NULL,
    "implicit_flow_enabled" boolean DEFAULT false NOT NULL,
    "direct_access_grants_enabled" boolean DEFAULT false NOT NULL,
    "always_display_in_console" boolean DEFAULT false NOT NULL,
    CONSTRAINT "constraint_7" PRIMARY KEY ("id"),
    CONSTRAINT "uk_b71cjlbenv945rb6gcon438at" UNIQUE ("realm_id", "client_id"),
    CONSTRAINT "fk_p56ctinxxb9gsk57fo49f9tac" FOREIGN KEY (realm_id) REFERENCES realm(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_client_id" ON "public"."client" USING btree ("client_id");


CREATE TABLE "public"."client_attributes" (
    "client_id" character varying(36) NOT NULL,
    "value" character varying(4000),
    "name" character varying(255) NOT NULL,
    CONSTRAINT "constraint_3c" PRIMARY KEY ("client_id", "name"),
    CONSTRAINT "fk3c47c64beacca966" FOREIGN KEY (client_id) REFERENCES client(id) NOT DEFERRABLE
) WITH (oids = false);


CREATE TABLE "public"."client_auth_flow_bindings" (
    "client_id" character varying(36) NOT NULL,
    "flow_id" character varying(36),
    "binding_name" character varying(255) NOT NULL,
    CONSTRAINT "c_cli_flow_bind" PRIMARY KEY ("client_id", "binding_name")
) WITH (oids = false);


CREATE TABLE "public"."client_default_roles" (
    "client_id" character varying(36) NOT NULL,
    "role_id" character varying(36) NOT NULL,
    CONSTRAINT "constr_client_default_roles" PRIMARY KEY ("client_id", "role_id"),
    CONSTRAINT "uk_8aelwnibji49avxsrtuf6xjow" UNIQUE ("role_id"),
    CONSTRAINT "fk_8aelwnibji49avxsrtuf6xjow" FOREIGN KEY (role_id) REFERENCES keycloak_role(id) NOT DEFERRABLE,
    CONSTRAINT "fk_nuilts7klwqw2h8m2b5joytky" FOREIGN KEY (client_id) REFERENCES client(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_client_def_roles_client" ON "public"."client_default_roles" USING btree ("client_id");


CREATE TABLE "public"."client_initial_access" (
    "id" character varying(36) NOT NULL,
    "realm_id" character varying(36) NOT NULL,
    "timestamp" integer,
    "expiration" integer,
    "count" integer,
    "remaining_count" integer,
    CONSTRAINT "cnstr_client_init_acc_pk" PRIMARY KEY ("id"),
    CONSTRAINT "fk_client_init_acc_realm" FOREIGN KEY (realm_id) REFERENCES realm(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_client_init_acc_realm" ON "public"."client_initial_access" USING btree ("realm_id");


CREATE TABLE "public"."client_node_registrations" (
    "client_id" character varying(36) NOT NULL,
    "value" integer,
    "name" character varying(255) NOT NULL,
    CONSTRAINT "constraint_84" PRIMARY KEY ("client_id", "name"),
    CONSTRAINT "fk4129723ba992f594" FOREIGN KEY (client_id) REFERENCES client(id) NOT DEFERRABLE
) WITH (oids = false);


CREATE TABLE "public"."client_scope" (
    "id" character varying(36) NOT NULL,
    "name" character varying(255),
    "realm_id" character varying(36),
    "description" character varying(255),
    "protocol" character varying(255),
    CONSTRAINT "pk_cli_template" PRIMARY KEY ("id"),
    CONSTRAINT "uk_cli_scope" UNIQUE ("realm_id", "name"),
    CONSTRAINT "fk_realm_cli_scope" FOREIGN KEY (realm_id) REFERENCES realm(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_realm_clscope" ON "public"."client_scope" USING btree ("realm_id");


CREATE TABLE "public"."client_scope_attributes" (
    "scope_id" character varying(36) NOT NULL,
    "value" character varying(2048),
    "name" character varying(255) NOT NULL,
    CONSTRAINT "pk_cl_tmpl_attr" PRIMARY KEY ("scope_id", "name"),
    CONSTRAINT "fk_cl_scope_attr_scope" FOREIGN KEY (scope_id) REFERENCES client_scope(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_clscope_attrs" ON "public"."client_scope_attributes" USING btree ("scope_id");


CREATE TABLE "public"."client_scope_client" (
    "client_id" character varying(36) NOT NULL,
    "scope_id" character varying(36) NOT NULL,
    "default_scope" boolean DEFAULT false NOT NULL,
    CONSTRAINT "c_cli_scope_bind" PRIMARY KEY ("client_id", "scope_id"),
    CONSTRAINT "fk_c_cli_scope_client" FOREIGN KEY (client_id) REFERENCES client(id) NOT DEFERRABLE,
    CONSTRAINT "fk_c_cli_scope_scope" FOREIGN KEY (scope_id) REFERENCES client_scope(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_cl_clscope" ON "public"."client_scope_client" USING btree ("scope_id");

CREATE INDEX "idx_clscope_cl" ON "public"."client_scope_client" USING btree ("client_id");


CREATE TABLE "public"."client_scope_role_mapping" (
    "scope_id" character varying(36) NOT NULL,
    "role_id" character varying(36) NOT NULL,
    CONSTRAINT "pk_template_scope" PRIMARY KEY ("scope_id", "role_id"),
    CONSTRAINT "fk_cl_scope_rm_role" FOREIGN KEY (role_id) REFERENCES keycloak_role(id) NOT DEFERRABLE,
    CONSTRAINT "fk_cl_scope_rm_scope" FOREIGN KEY (scope_id) REFERENCES client_scope(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_clscope_role" ON "public"."client_scope_role_mapping" USING btree ("scope_id");

CREATE INDEX "idx_role_clscope" ON "public"."client_scope_role_mapping" USING btree ("role_id");


CREATE TABLE "public"."client_session" (
    "id" character varying(36) NOT NULL,
    "client_id" character varying(36),
    "redirect_uri" character varying(255),
    "state" character varying(255),
    "timestamp" integer,
    "session_id" character varying(36),
    "auth_method" character varying(255),
    "realm_id" character varying(255),
    "auth_user_id" character varying(36),
    "current_action" character varying(36),
    CONSTRAINT "constraint_8" PRIMARY KEY ("id"),
    CONSTRAINT "fk_b4ao2vcvat6ukau74wbwtfqo1" FOREIGN KEY (session_id) REFERENCES user_session(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_client_session_session" ON "public"."client_session" USING btree ("session_id");


CREATE TABLE "public"."client_session_auth_status" (
    "authenticator" character varying(36) NOT NULL,
    "status" integer,
    "client_session" character varying(36) NOT NULL,
    CONSTRAINT "constraint_auth_status_pk" PRIMARY KEY ("client_session", "authenticator"),
    CONSTRAINT "auth_status_constraint" FOREIGN KEY (client_session) REFERENCES client_session(id) NOT DEFERRABLE
) WITH (oids = false);


CREATE TABLE "public"."client_session_note" (
    "name" character varying(255) NOT NULL,
    "value" character varying(255),
    "client_session" character varying(36) NOT NULL,
    CONSTRAINT "constraint_5e" PRIMARY KEY ("client_session", "name"),
    CONSTRAINT "fk5edfb00ff51c2736" FOREIGN KEY (client_session) REFERENCES client_session(id) NOT DEFERRABLE
) WITH (oids = false);


CREATE TABLE "public"."client_session_prot_mapper" (
    "protocol_mapper_id" character varying(36) NOT NULL,
    "client_session" character varying(36) NOT NULL,
    CONSTRAINT "constraint_cs_pmp_pk" PRIMARY KEY ("client_session", "protocol_mapper_id"),
    CONSTRAINT "fk_33a8sgqw18i532811v7o2dk89" FOREIGN KEY (client_session) REFERENCES client_session(id) NOT DEFERRABLE
) WITH (oids = false);


CREATE TABLE "public"."client_session_role" (
    "role_id" character varying(255) NOT NULL,
    "client_session" character varying(36) NOT NULL,
    CONSTRAINT "constraint_5" PRIMARY KEY ("client_session", "role_id"),
    CONSTRAINT "fk_11b7sgqw18i532811v7o2dv76" FOREIGN KEY (client_session) REFERENCES client_session(id) NOT DEFERRABLE
) WITH (oids = false);


CREATE TABLE "public"."client_user_session_note" (
    "name" character varying(255) NOT NULL,
    "value" character varying(2048),
    "client_session" character varying(36) NOT NULL,
    CONSTRAINT "constr_cl_usr_ses_note" PRIMARY KEY ("client_session", "name"),
    CONSTRAINT "fk_cl_usr_ses_note" FOREIGN KEY (client_session) REFERENCES client_session(id) NOT DEFERRABLE
) WITH (oids = false);


CREATE TABLE "public"."component" (
    "id" character varying(36) NOT NULL,
    "name" character varying(255),
    "parent_id" character varying(36),
    "provider_id" character varying(36),
    "provider_type" character varying(255),
    "realm_id" character varying(36),
    "sub_type" character varying(255),
    CONSTRAINT "constr_component_pk" PRIMARY KEY ("id"),
    CONSTRAINT "fk_component_realm" FOREIGN KEY (realm_id) REFERENCES realm(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_component_provider_type" ON "public"."component" USING btree ("provider_type");

CREATE INDEX "idx_component_realm" ON "public"."component" USING btree ("realm_id");


CREATE TABLE "public"."component_config" (
    "id" character varying(36) NOT NULL,
    "component_id" character varying(36) NOT NULL,
    "name" character varying(255) NOT NULL,
    "value" character varying(4000),
    CONSTRAINT "constr_component_config_pk" PRIMARY KEY ("id"),
    CONSTRAINT "fk_component_config" FOREIGN KEY (component_id) REFERENCES component(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_compo_config_compo" ON "public"."component_config" USING btree ("component_id");


CREATE TABLE "public"."composite_role" (
    "composite" character varying(36) NOT NULL,
    "child_role" character varying(36) NOT NULL,
    CONSTRAINT "constraint_composite_role" PRIMARY KEY ("composite", "child_role"),
    CONSTRAINT "fk_a63wvekftu8jo1pnj81e7mce2" FOREIGN KEY (composite) REFERENCES keycloak_role(id) NOT DEFERRABLE,
    CONSTRAINT "fk_gr7thllb9lu8q4vqa4524jjy8" FOREIGN KEY (child_role) REFERENCES keycloak_role(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_composite" ON "public"."composite_role" USING btree ("composite");

CREATE INDEX "idx_composite_child" ON "public"."composite_role" USING btree ("child_role");


CREATE TABLE "public"."credential" (
    "id" character varying(36) NOT NULL,
    "salt" bytea,
    "type" character varying(255),
    "user_id" character varying(36),
    "created_date" bigint,
    "user_label" character varying(255),
    "secret_data" text,
    "credential_data" text,
    "priority" integer,
    CONSTRAINT "constraint_f" PRIMARY KEY ("id"),
    CONSTRAINT "fk_pfyr0glasqyl0dei3kl69r6v0" FOREIGN KEY (user_id) REFERENCES user_entity(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_user_credential" ON "public"."credential" USING btree ("user_id");


CREATE TABLE "public"."databasechangelog" (
    "id" character varying(255) NOT NULL,
    "author" character varying(255) NOT NULL,
    "filename" character varying(255) NOT NULL,
    "dateexecuted" timestamp NOT NULL,
    "orderexecuted" integer NOT NULL,
    "exectype" character varying(10) NOT NULL,
    "md5sum" character varying(35),
    "description" character varying(255),
    "comments" character varying(255),
    "tag" character varying(255),
    "liquibase" character varying(20),
    "contexts" character varying(255),
    "labels" character varying(255),
    "deployment_id" character varying(10)
) WITH (oids = false);


CREATE TABLE "public"."databasechangeloglock" (
    "id" integer NOT NULL,
    "locked" boolean NOT NULL,
    "lockgranted" timestamp,
    "lockedby" character varying(255),
    CONSTRAINT "pk_databasechangeloglock" PRIMARY KEY ("id")
) WITH (oids = false);


CREATE TABLE "public"."default_client_scope" (
    "realm_id" character varying(36) NOT NULL,
    "scope_id" character varying(36) NOT NULL,
    "default_scope" boolean DEFAULT false NOT NULL,
    CONSTRAINT "r_def_cli_scope_bind" PRIMARY KEY ("realm_id", "scope_id"),
    CONSTRAINT "fk_r_def_cli_scope_realm" FOREIGN KEY (realm_id) REFERENCES realm(id) NOT DEFERRABLE,
    CONSTRAINT "fk_r_def_cli_scope_scope" FOREIGN KEY (scope_id) REFERENCES client_scope(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_defcls_realm" ON "public"."default_client_scope" USING btree ("realm_id");

CREATE INDEX "idx_defcls_scope" ON "public"."default_client_scope" USING btree ("scope_id");


CREATE TABLE "public"."event_entity" (
    "id" character varying(36) NOT NULL,
    "client_id" character varying(255),
    "details_json" character varying(2550),
    "error" character varying(255),
    "ip_address" character varying(255),
    "realm_id" character varying(255),
    "session_id" character varying(255),
    "event_time" bigint,
    "type" character varying(255),
    "user_id" character varying(255),
    CONSTRAINT "constraint_4" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "idx_event_time" ON "public"."event_entity" USING btree ("realm_id", "event_time");


CREATE TABLE "public"."fed_user_attribute" (
    "id" character varying(36) NOT NULL,
    "name" character varying(255) NOT NULL,
    "user_id" character varying(255) NOT NULL,
    "realm_id" character varying(36) NOT NULL,
    "storage_provider_id" character varying(36),
    "value" character varying(2024),
    CONSTRAINT "constr_fed_user_attr_pk" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "idx_fu_attribute" ON "public"."fed_user_attribute" USING btree ("user_id", "realm_id", "name");


CREATE TABLE "public"."fed_user_consent" (
    "id" character varying(36) NOT NULL,
    "client_id" character varying(255),
    "user_id" character varying(255) NOT NULL,
    "realm_id" character varying(36) NOT NULL,
    "storage_provider_id" character varying(36),
    "created_date" bigint,
    "last_updated_date" bigint,
    "client_storage_provider" character varying(36),
    "external_client_id" character varying(255),
    CONSTRAINT "constr_fed_user_consent_pk" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "idx_fu_cnsnt_ext" ON "public"."fed_user_consent" USING btree ("user_id", "client_storage_provider", "external_client_id");

CREATE INDEX "idx_fu_consent" ON "public"."fed_user_consent" USING btree ("user_id", "client_id");

CREATE INDEX "idx_fu_consent_ru" ON "public"."fed_user_consent" USING btree ("realm_id", "user_id");


CREATE TABLE "public"."fed_user_consent_cl_scope" (
    "user_consent_id" character varying(36) NOT NULL,
    "scope_id" character varying(36) NOT NULL,
    CONSTRAINT "constraint_fgrntcsnt_clsc_pm" PRIMARY KEY ("user_consent_id", "scope_id")
) WITH (oids = false);


CREATE TABLE "public"."fed_user_credential" (
    "id" character varying(36) NOT NULL,
    "salt" bytea,
    "type" character varying(255),
    "created_date" bigint,
    "user_id" character varying(255) NOT NULL,
    "realm_id" character varying(36) NOT NULL,
    "storage_provider_id" character varying(36),
    "user_label" character varying(255),
    "secret_data" text,
    "credential_data" text,
    "priority" integer,
    CONSTRAINT "constr_fed_user_cred_pk" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "idx_fu_credential" ON "public"."fed_user_credential" USING btree ("user_id", "type");

CREATE INDEX "idx_fu_credential_ru" ON "public"."fed_user_credential" USING btree ("realm_id", "user_id");


CREATE TABLE "public"."fed_user_group_membership" (
    "group_id" character varying(36) NOT NULL,
    "user_id" character varying(255) NOT NULL,
    "realm_id" character varying(36) NOT NULL,
    "storage_provider_id" character varying(36),
    CONSTRAINT "constr_fed_user_group" PRIMARY KEY ("group_id", "user_id")
) WITH (oids = false);

CREATE INDEX "idx_fu_group_membership" ON "public"."fed_user_group_membership" USING btree ("user_id", "group_id");

CREATE INDEX "idx_fu_group_membership_ru" ON "public"."fed_user_group_membership" USING btree ("realm_id", "user_id");


CREATE TABLE "public"."fed_user_required_action" (
    "required_action" character varying(255) DEFAULT ' ' NOT NULL,
    "user_id" character varying(255) NOT NULL,
    "realm_id" character varying(36) NOT NULL,
    "storage_provider_id" character varying(36),
    CONSTRAINT "constr_fed_required_action" PRIMARY KEY ("required_action", "user_id")
) WITH (oids = false);

CREATE INDEX "idx_fu_required_action" ON "public"."fed_user_required_action" USING btree ("user_id", "required_action");

CREATE INDEX "idx_fu_required_action_ru" ON "public"."fed_user_required_action" USING btree ("realm_id", "user_id");


CREATE TABLE "public"."fed_user_role_mapping" (
    "role_id" character varying(36) NOT NULL,
    "user_id" character varying(255) NOT NULL,
    "realm_id" character varying(36) NOT NULL,
    "storage_provider_id" character varying(36),
    CONSTRAINT "constr_fed_user_role" PRIMARY KEY ("role_id", "user_id")
) WITH (oids = false);

CREATE INDEX "idx_fu_role_mapping" ON "public"."fed_user_role_mapping" USING btree ("user_id", "role_id");

CREATE INDEX "idx_fu_role_mapping_ru" ON "public"."fed_user_role_mapping" USING btree ("realm_id", "user_id");


CREATE TABLE "public"."federated_identity" (
    "identity_provider" character varying(255) NOT NULL,
    "realm_id" character varying(36),
    "federated_user_id" character varying(255),
    "federated_username" character varying(255),
    "token" text,
    "user_id" character varying(36) NOT NULL,
    CONSTRAINT "constraint_40" PRIMARY KEY ("identity_provider", "user_id"),
    CONSTRAINT "fk404288b92ef007a6" FOREIGN KEY (user_id) REFERENCES user_entity(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_fedidentity_feduser" ON "public"."federated_identity" USING btree ("federated_user_id");

CREATE INDEX "idx_fedidentity_user" ON "public"."federated_identity" USING btree ("user_id");


CREATE TABLE "public"."federated_user" (
    "id" character varying(255) NOT NULL,
    "storage_provider_id" character varying(255),
    "realm_id" character varying(36) NOT NULL,
    CONSTRAINT "constr_federated_user" PRIMARY KEY ("id")
) WITH (oids = false);


CREATE TABLE "public"."group_attribute" (
    "id" character varying(36) DEFAULT 'sybase-needs-something-here' NOT NULL,
    "name" character varying(255) NOT NULL,
    "value" character varying(255),
    "group_id" character varying(36) NOT NULL,
    CONSTRAINT "constraint_group_attribute_pk" PRIMARY KEY ("id"),
    CONSTRAINT "fk_group_attribute_group" FOREIGN KEY (group_id) REFERENCES keycloak_group(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_group_attr_group" ON "public"."group_attribute" USING btree ("group_id");


CREATE TABLE "public"."group_role_mapping" (
    "role_id" character varying(36) NOT NULL,
    "group_id" character varying(36) NOT NULL,
    CONSTRAINT "constraint_group_role" PRIMARY KEY ("role_id", "group_id"),
    CONSTRAINT "fk_group_role_group" FOREIGN KEY (group_id) REFERENCES keycloak_group(id) NOT DEFERRABLE,
    CONSTRAINT "fk_group_role_role" FOREIGN KEY (role_id) REFERENCES keycloak_role(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_group_role_mapp_group" ON "public"."group_role_mapping" USING btree ("group_id");


CREATE TABLE "public"."identity_provider" (
    "internal_id" character varying(36) NOT NULL,
    "enabled" boolean DEFAULT false NOT NULL,
    "provider_alias" character varying(255),
    "provider_id" character varying(255),
    "store_token" boolean DEFAULT false NOT NULL,
    "authenticate_by_default" boolean DEFAULT false NOT NULL,
    "realm_id" character varying(36),
    "add_token_role" boolean DEFAULT true NOT NULL,
    "trust_email" boolean DEFAULT false NOT NULL,
    "first_broker_login_flow_id" character varying(36),
    "post_broker_login_flow_id" character varying(36),
    "provider_display_name" character varying(255),
    "link_only" boolean DEFAULT false NOT NULL,
    CONSTRAINT "constraint_2b" PRIMARY KEY ("internal_id"),
    CONSTRAINT "uk_2daelwnibji49avxsrtuf6xj33" UNIQUE ("provider_alias", "realm_id"),
    CONSTRAINT "fk2b4ebc52ae5c3b34" FOREIGN KEY (realm_id) REFERENCES realm(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_ident_prov_realm" ON "public"."identity_provider" USING btree ("realm_id");


CREATE TABLE "public"."identity_provider_config" (
    "identity_provider_id" character varying(36) NOT NULL,
    "value" text,
    "name" character varying(255) NOT NULL,
    CONSTRAINT "constraint_d" PRIMARY KEY ("identity_provider_id", "name"),
    CONSTRAINT "fkdc4897cf864c4e43" FOREIGN KEY (identity_provider_id) REFERENCES identity_provider(internal_id) NOT DEFERRABLE
) WITH (oids = false);


CREATE TABLE "public"."identity_provider_mapper" (
    "id" character varying(36) NOT NULL,
    "name" character varying(255) NOT NULL,
    "idp_alias" character varying(255) NOT NULL,
    "idp_mapper_name" character varying(255) NOT NULL,
    "realm_id" character varying(36) NOT NULL,
    CONSTRAINT "constraint_idpm" PRIMARY KEY ("id"),
    CONSTRAINT "fk_idpm_realm" FOREIGN KEY (realm_id) REFERENCES realm(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_id_prov_mapp_realm" ON "public"."identity_provider_mapper" USING btree ("realm_id");


CREATE TABLE "public"."idp_mapper_config" (
    "idp_mapper_id" character varying(36) NOT NULL,
    "value" text,
    "name" character varying(255) NOT NULL,
    CONSTRAINT "constraint_idpmconfig" PRIMARY KEY ("idp_mapper_id", "name"),
    CONSTRAINT "fk_idpmconfig" FOREIGN KEY (idp_mapper_id) REFERENCES identity_provider_mapper(id) NOT DEFERRABLE
) WITH (oids = false);


CREATE TABLE "public"."keycloak_group" (
    "id" character varying(36) NOT NULL,
    "name" character varying(255),
    "parent_group" character varying(36) NOT NULL,
    "realm_id" character varying(36),
    CONSTRAINT "constraint_group" PRIMARY KEY ("id"),
    CONSTRAINT "sibling_names" UNIQUE ("realm_id", "parent_group", "name"),
    CONSTRAINT "fk_group_realm" FOREIGN KEY (realm_id) REFERENCES realm(id) NOT DEFERRABLE
) WITH (oids = false);


CREATE TABLE "public"."keycloak_role" (
    "id" character varying(36) NOT NULL,
    "client_realm_constraint" character varying(255),
    "client_role" boolean DEFAULT false NOT NULL,
    "description" character varying(255),
    "name" character varying(255),
    "realm_id" character varying(255),
    "client" character varying(36),
    "realm" character varying(36),
    CONSTRAINT "UK_J3RWUVD56ONTGSUHOGM184WW2-2" UNIQUE ("name", "client_realm_constraint"),
    CONSTRAINT "constraint_a" PRIMARY KEY ("id"),
    CONSTRAINT "fk_6vyqfe4cn4wlq8r6kt5vdsj5c" FOREIGN KEY (realm) REFERENCES realm(id) NOT DEFERRABLE,
    CONSTRAINT "fk_kjho5le2c0ral09fl8cm9wfw9" FOREIGN KEY (client) REFERENCES client(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_keycloak_role_client" ON "public"."keycloak_role" USING btree ("client");

CREATE INDEX "idx_keycloak_role_realm" ON "public"."keycloak_role" USING btree ("realm");


CREATE TABLE "public"."migration_model" (
    "id" character varying(36) NOT NULL,
    "version" character varying(36),
    "update_time" bigint DEFAULT '0' NOT NULL,
    CONSTRAINT "constraint_migmod" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "idx_update_time" ON "public"."migration_model" USING btree ("update_time");


CREATE TABLE "public"."offline_client_session" (
    "user_session_id" character varying(36) NOT NULL,
    "client_id" character varying(255) NOT NULL,
    "offline_flag" character varying(4) NOT NULL,
    "timestamp" integer,
    "data" text,
    "client_storage_provider" character varying(36) DEFAULT 'local' NOT NULL,
    "external_client_id" character varying(255) DEFAULT 'local' NOT NULL,
    CONSTRAINT "constraint_offl_cl_ses_pk3" PRIMARY KEY ("user_session_id", "client_id", "client_storage_provider", "external_client_id", "offline_flag")
) WITH (oids = false);

CREATE INDEX "idx_us_sess_id_on_cl_sess" ON "public"."offline_client_session" USING btree ("user_session_id");


CREATE TABLE "public"."offline_user_session" (
    "user_session_id" character varying(36) NOT NULL,
    "user_id" character varying(255) NOT NULL,
    "realm_id" character varying(36) NOT NULL,
    "created_on" integer NOT NULL,
    "offline_flag" character varying(4) NOT NULL,
    "data" text,
    "last_session_refresh" integer DEFAULT '0' NOT NULL,
    CONSTRAINT "constraint_offl_us_ses_pk2" PRIMARY KEY ("user_session_id", "offline_flag")
) WITH (oids = false);

CREATE INDEX "idx_offline_uss_createdon" ON "public"."offline_user_session" USING btree ("created_on");


CREATE TABLE "public"."policy_config" (
    "policy_id" character varying(36) NOT NULL,
    "name" character varying(255) NOT NULL,
    "value" text,
    CONSTRAINT "constraint_dpc" PRIMARY KEY ("policy_id", "name"),
    CONSTRAINT "fkdc34197cf864c4e43" FOREIGN KEY (policy_id) REFERENCES resource_server_policy(id) NOT DEFERRABLE
) WITH (oids = false);


CREATE TABLE "public"."protocol_mapper" (
    "id" character varying(36) NOT NULL,
    "name" character varying(255) NOT NULL,
    "protocol" character varying(255) NOT NULL,
    "protocol_mapper_name" character varying(255) NOT NULL,
    "client_id" character varying(36),
    "client_scope_id" character varying(36),
    CONSTRAINT "constraint_pcm" PRIMARY KEY ("id"),
    CONSTRAINT "fk_cli_scope_mapper" FOREIGN KEY (client_scope_id) REFERENCES client_scope(id) NOT DEFERRABLE,
    CONSTRAINT "fk_pcm_realm" FOREIGN KEY (client_id) REFERENCES client(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_clscope_protmap" ON "public"."protocol_mapper" USING btree ("client_scope_id");

CREATE INDEX "idx_protocol_mapper_client" ON "public"."protocol_mapper" USING btree ("client_id");


CREATE TABLE "public"."protocol_mapper_config" (
    "protocol_mapper_id" character varying(36) NOT NULL,
    "value" text,
    "name" character varying(255) NOT NULL,
    CONSTRAINT "constraint_pmconfig" PRIMARY KEY ("protocol_mapper_id", "name"),
    CONSTRAINT "fk_pmconfig" FOREIGN KEY (protocol_mapper_id) REFERENCES protocol_mapper(id) NOT DEFERRABLE
) WITH (oids = false);


CREATE TABLE "public"."realm" (
    "id" character varying(36) NOT NULL,
    "access_code_lifespan" integer,
    "user_action_lifespan" integer,
    "access_token_lifespan" integer,
    "account_theme" character varying(255),
    "admin_theme" character varying(255),
    "email_theme" character varying(255),
    "enabled" boolean DEFAULT false NOT NULL,
    "events_enabled" boolean DEFAULT false NOT NULL,
    "events_expiration" bigint,
    "login_theme" character varying(255),
    "name" character varying(255),
    "not_before" integer,
    "password_policy" character varying(2550),
    "registration_allowed" boolean DEFAULT false NOT NULL,
    "remember_me" boolean DEFAULT false NOT NULL,
    "reset_password_allowed" boolean DEFAULT false NOT NULL,
    "social" boolean DEFAULT false NOT NULL,
    "ssl_required" character varying(255),
    "sso_idle_timeout" integer,
    "sso_max_lifespan" integer,
    "update_profile_on_soc_login" boolean DEFAULT false NOT NULL,
    "verify_email" boolean DEFAULT false NOT NULL,
    "master_admin_client" character varying(36),
    "login_lifespan" integer,
    "internationalization_enabled" boolean DEFAULT false NOT NULL,
    "default_locale" character varying(255),
    "reg_email_as_username" boolean DEFAULT false NOT NULL,
    "admin_events_enabled" boolean DEFAULT false NOT NULL,
    "admin_events_details_enabled" boolean DEFAULT false NOT NULL,
    "edit_username_allowed" boolean DEFAULT false NOT NULL,
    "otp_policy_counter" integer DEFAULT '0',
    "otp_policy_window" integer DEFAULT '1',
    "otp_policy_period" integer DEFAULT '30',
    "otp_policy_digits" integer DEFAULT '6',
    "otp_policy_alg" character varying(36) DEFAULT 'HmacSHA1',
    "otp_policy_type" character varying(36) DEFAULT 'totp',
    "browser_flow" character varying(36),
    "registration_flow" character varying(36),
    "direct_grant_flow" character varying(36),
    "reset_credentials_flow" character varying(36),
    "client_auth_flow" character varying(36),
    "offline_session_idle_timeout" integer DEFAULT '0',
    "revoke_refresh_token" boolean DEFAULT false NOT NULL,
    "access_token_life_implicit" integer DEFAULT '0',
    "login_with_email_allowed" boolean DEFAULT true NOT NULL,
    "duplicate_emails_allowed" boolean DEFAULT false NOT NULL,
    "docker_auth_flow" character varying(36),
    "refresh_token_max_reuse" integer DEFAULT '0',
    "allow_user_managed_access" boolean DEFAULT false NOT NULL,
    "sso_max_lifespan_remember_me" integer DEFAULT '0' NOT NULL,
    "sso_idle_timeout_remember_me" integer DEFAULT '0' NOT NULL,
    CONSTRAINT "constraint_4a" PRIMARY KEY ("id"),
    CONSTRAINT "uk_orvsdmla56612eaefiq6wl5oi" UNIQUE ("name"),
    CONSTRAINT "fk_traf444kk6qrkms7n56aiwq5y" FOREIGN KEY (master_admin_client) REFERENCES client(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_realm_master_adm_cli" ON "public"."realm" USING btree ("master_admin_client");


CREATE TABLE "public"."realm_attribute" (
    "name" character varying(255) NOT NULL,
    "value" character varying(255),
    "realm_id" character varying(36) NOT NULL,
    CONSTRAINT "constraint_9" PRIMARY KEY ("name", "realm_id"),
    CONSTRAINT "fk_8shxd6l3e9atqukacxgpffptw" FOREIGN KEY (realm_id) REFERENCES realm(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_realm_attr_realm" ON "public"."realm_attribute" USING btree ("realm_id");


CREATE TABLE "public"."realm_default_groups" (
    "realm_id" character varying(36) NOT NULL,
    "group_id" character varying(36) NOT NULL,
    CONSTRAINT "con_group_id_def_groups" UNIQUE ("group_id"),
    CONSTRAINT "constr_realm_default_groups" PRIMARY KEY ("realm_id", "group_id"),
    CONSTRAINT "fk_def_groups_group" FOREIGN KEY (group_id) REFERENCES keycloak_group(id) NOT DEFERRABLE,
    CONSTRAINT "fk_def_groups_realm" FOREIGN KEY (realm_id) REFERENCES realm(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_realm_def_grp_realm" ON "public"."realm_default_groups" USING btree ("realm_id");


CREATE TABLE "public"."realm_default_roles" (
    "realm_id" character varying(36) NOT NULL,
    "role_id" character varying(36) NOT NULL,
    CONSTRAINT "constraint_realm_default_roles" PRIMARY KEY ("realm_id", "role_id"),
    CONSTRAINT "uk_h4wpd7w4hsoolni3h0sw7btje" UNIQUE ("role_id"),
    CONSTRAINT "fk_evudb1ppw84oxfax2drs03icc" FOREIGN KEY (realm_id) REFERENCES realm(id) NOT DEFERRABLE,
    CONSTRAINT "fk_h4wpd7w4hsoolni3h0sw7btje" FOREIGN KEY (role_id) REFERENCES keycloak_role(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_realm_def_roles_realm" ON "public"."realm_default_roles" USING btree ("realm_id");


CREATE TABLE "public"."realm_enabled_event_types" (
    "realm_id" character varying(36) NOT NULL,
    "value" character varying(255) NOT NULL,
    CONSTRAINT "constr_realm_enabl_event_types" PRIMARY KEY ("realm_id", "value"),
    CONSTRAINT "fk_h846o4h0w8epx5nwedrf5y69j" FOREIGN KEY (realm_id) REFERENCES realm(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_realm_evt_types_realm" ON "public"."realm_enabled_event_types" USING btree ("realm_id");


CREATE TABLE "public"."realm_events_listeners" (
    "realm_id" character varying(36) NOT NULL,
    "value" character varying(255) NOT NULL,
    CONSTRAINT "constr_realm_events_listeners" PRIMARY KEY ("realm_id", "value"),
    CONSTRAINT "fk_h846o4h0w8epx5nxev9f5y69j" FOREIGN KEY (realm_id) REFERENCES realm(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_realm_evt_list_realm" ON "public"."realm_events_listeners" USING btree ("realm_id");


CREATE TABLE "public"."realm_required_credential" (
    "type" character varying(255) NOT NULL,
    "form_label" character varying(255),
    "input" boolean DEFAULT false NOT NULL,
    "secret" boolean DEFAULT false NOT NULL,
    "realm_id" character varying(36) NOT NULL,
    CONSTRAINT "constraint_92" PRIMARY KEY ("realm_id", "type"),
    CONSTRAINT "fk_5hg65lybevavkqfki3kponh9v" FOREIGN KEY (realm_id) REFERENCES realm(id) NOT DEFERRABLE
) WITH (oids = false);


CREATE TABLE "public"."realm_smtp_config" (
    "realm_id" character varying(36) NOT NULL,
    "value" character varying(255),
    "name" character varying(255) NOT NULL,
    CONSTRAINT "constraint_e" PRIMARY KEY ("realm_id", "name"),
    CONSTRAINT "fk_70ej8xdxgxd0b9hh6180irr0o" FOREIGN KEY (realm_id) REFERENCES realm(id) NOT DEFERRABLE
) WITH (oids = false);


CREATE TABLE "public"."realm_supported_locales" (
    "realm_id" character varying(36) NOT NULL,
    "value" character varying(255) NOT NULL,
    CONSTRAINT "constr_realm_supported_locales" PRIMARY KEY ("realm_id", "value"),
    CONSTRAINT "fk_supported_locales_realm" FOREIGN KEY (realm_id) REFERENCES realm(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_realm_supp_local_realm" ON "public"."realm_supported_locales" USING btree ("realm_id");


CREATE TABLE "public"."redirect_uris" (
    "client_id" character varying(36) NOT NULL,
    "value" character varying(255) NOT NULL,
    CONSTRAINT "constraint_redirect_uris" PRIMARY KEY ("client_id", "value"),
    CONSTRAINT "fk_1burs8pb4ouj97h5wuppahv9f" FOREIGN KEY (client_id) REFERENCES client(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_redir_uri_client" ON "public"."redirect_uris" USING btree ("client_id");


CREATE TABLE "public"."required_action_config" (
    "required_action_id" character varying(36) NOT NULL,
    "value" text,
    "name" character varying(255) NOT NULL,
    CONSTRAINT "constraint_req_act_cfg_pk" PRIMARY KEY ("required_action_id", "name")
) WITH (oids = false);


CREATE TABLE "public"."required_action_provider" (
    "id" character varying(36) NOT NULL,
    "alias" character varying(255),
    "name" character varying(255),
    "realm_id" character varying(36),
    "enabled" boolean DEFAULT false NOT NULL,
    "default_action" boolean DEFAULT false NOT NULL,
    "provider_id" character varying(255),
    "priority" integer,
    CONSTRAINT "constraint_req_act_prv_pk" PRIMARY KEY ("id"),
    CONSTRAINT "fk_req_act_realm" FOREIGN KEY (realm_id) REFERENCES realm(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_req_act_prov_realm" ON "public"."required_action_provider" USING btree ("realm_id");


CREATE TABLE "public"."resource_attribute" (
    "id" character varying(36) DEFAULT 'sybase-needs-something-here' NOT NULL,
    "name" character varying(255) NOT NULL,
    "value" character varying(255),
    "resource_id" character varying(36) NOT NULL,
    CONSTRAINT "res_attr_pk" PRIMARY KEY ("id"),
    CONSTRAINT "fk_5hrm2vlf9ql5fu022kqepovbr" FOREIGN KEY (resource_id) REFERENCES resource_server_resource(id) NOT DEFERRABLE
) WITH (oids = false);


CREATE TABLE "public"."resource_policy" (
    "resource_id" character varying(36) NOT NULL,
    "policy_id" character varying(36) NOT NULL,
    CONSTRAINT "constraint_farsrpp" PRIMARY KEY ("resource_id", "policy_id"),
    CONSTRAINT "fk_frsrpos53xcx4wnkog82ssrfy" FOREIGN KEY (resource_id) REFERENCES resource_server_resource(id) NOT DEFERRABLE,
    CONSTRAINT "fk_frsrpp213xcx4wnkog82ssrfy" FOREIGN KEY (policy_id) REFERENCES resource_server_policy(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_res_policy_policy" ON "public"."resource_policy" USING btree ("policy_id");


CREATE TABLE "public"."resource_scope" (
    "resource_id" character varying(36) NOT NULL,
    "scope_id" character varying(36) NOT NULL,
    CONSTRAINT "constraint_farsrsp" PRIMARY KEY ("resource_id", "scope_id"),
    CONSTRAINT "fk_frsrpos13xcx4wnkog82ssrfy" FOREIGN KEY (resource_id) REFERENCES resource_server_resource(id) NOT DEFERRABLE,
    CONSTRAINT "fk_frsrps213xcx4wnkog82ssrfy" FOREIGN KEY (scope_id) REFERENCES resource_server_scope(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_res_scope_scope" ON "public"."resource_scope" USING btree ("scope_id");


CREATE TABLE "public"."resource_server" (
    "id" character varying(36) NOT NULL,
    "allow_rs_remote_mgmt" boolean DEFAULT false NOT NULL,
    "policy_enforce_mode" character varying(15) NOT NULL,
    "decision_strategy" smallint DEFAULT '1' NOT NULL,
    CONSTRAINT "pk_resource_server" PRIMARY KEY ("id")
) WITH (oids = false);


CREATE TABLE "public"."resource_server_perm_ticket" (
    "id" character varying(36) NOT NULL,
    "owner" character varying(255) NOT NULL,
    "requester" character varying(255) NOT NULL,
    "created_timestamp" bigint NOT NULL,
    "granted_timestamp" bigint,
    "resource_id" character varying(36) NOT NULL,
    "scope_id" character varying(36),
    "resource_server_id" character varying(36) NOT NULL,
    "policy_id" character varying(36),
    CONSTRAINT "constraint_fapmt" PRIMARY KEY ("id"),
    CONSTRAINT "uk_frsr6t700s9v50bu18ws5pmt" UNIQUE ("owner", "requester", "resource_server_id", "resource_id", "scope_id"),
    CONSTRAINT "fk_frsrho213xcx4wnkog82sspmt" FOREIGN KEY (resource_server_id) REFERENCES resource_server(id) NOT DEFERRABLE,
    CONSTRAINT "fk_frsrho213xcx4wnkog83sspmt" FOREIGN KEY (resource_id) REFERENCES resource_server_resource(id) NOT DEFERRABLE,
    CONSTRAINT "fk_frsrho213xcx4wnkog84sspmt" FOREIGN KEY (scope_id) REFERENCES resource_server_scope(id) NOT DEFERRABLE,
    CONSTRAINT "fk_frsrpo2128cx4wnkog82ssrfy" FOREIGN KEY (policy_id) REFERENCES resource_server_policy(id) NOT DEFERRABLE
) WITH (oids = false);


CREATE TABLE "public"."resource_server_policy" (
    "id" character varying(36) NOT NULL,
    "name" character varying(255) NOT NULL,
    "description" character varying(255),
    "type" character varying(255) NOT NULL,
    "decision_strategy" character varying(20),
    "logic" character varying(20),
    "resource_server_id" character varying(36) NOT NULL,
    "owner" character varying(255),
    CONSTRAINT "constraint_farsrp" PRIMARY KEY ("id"),
    CONSTRAINT "uk_frsrpt700s9v50bu18ws5ha6" UNIQUE ("name", "resource_server_id"),
    CONSTRAINT "fk_frsrpo213xcx4wnkog82ssrfy" FOREIGN KEY (resource_server_id) REFERENCES resource_server(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_res_serv_pol_res_serv" ON "public"."resource_server_policy" USING btree ("resource_server_id");


CREATE TABLE "public"."resource_server_resource" (
    "id" character varying(36) NOT NULL,
    "name" character varying(255) NOT NULL,
    "type" character varying(255),
    "icon_uri" character varying(255),
    "owner" character varying(255) NOT NULL,
    "resource_server_id" character varying(36) NOT NULL,
    "owner_managed_access" boolean DEFAULT false NOT NULL,
    "display_name" character varying(255),
    CONSTRAINT "constraint_farsr" PRIMARY KEY ("id"),
    CONSTRAINT "uk_frsr6t700s9v50bu18ws5ha6" UNIQUE ("name", "owner", "resource_server_id"),
    CONSTRAINT "fk_frsrho213xcx4wnkog82ssrfy" FOREIGN KEY (resource_server_id) REFERENCES resource_server(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_res_srv_res_res_srv" ON "public"."resource_server_resource" USING btree ("resource_server_id");


CREATE TABLE "public"."resource_server_scope" (
    "id" character varying(36) NOT NULL,
    "name" character varying(255) NOT NULL,
    "icon_uri" character varying(255),
    "resource_server_id" character varying(36) NOT NULL,
    "display_name" character varying(255),
    CONSTRAINT "constraint_farsrs" PRIMARY KEY ("id"),
    CONSTRAINT "uk_frsrst700s9v50bu18ws5ha6" UNIQUE ("name", "resource_server_id"),
    CONSTRAINT "fk_frsrso213xcx4wnkog82ssrfy" FOREIGN KEY (resource_server_id) REFERENCES resource_server(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_res_srv_scope_res_srv" ON "public"."resource_server_scope" USING btree ("resource_server_id");


CREATE TABLE "public"."resource_uris" (
    "resource_id" character varying(36) NOT NULL,
    "value" character varying(255) NOT NULL,
    CONSTRAINT "constraint_resour_uris_pk" PRIMARY KEY ("resource_id", "value"),
    CONSTRAINT "fk_resource_server_uris" FOREIGN KEY (resource_id) REFERENCES resource_server_resource(id) NOT DEFERRABLE
) WITH (oids = false);


CREATE TABLE "public"."role_attribute" (
    "id" character varying(36) NOT NULL,
    "role_id" character varying(36) NOT NULL,
    "name" character varying(255) NOT NULL,
    "value" character varying(255),
    CONSTRAINT "constraint_role_attribute_pk" PRIMARY KEY ("id"),
    CONSTRAINT "fk_role_attribute_id" FOREIGN KEY (role_id) REFERENCES keycloak_role(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_role_attribute" ON "public"."role_attribute" USING btree ("role_id");


CREATE TABLE "public"."scope_mapping" (
    "client_id" character varying(36) NOT NULL,
    "role_id" character varying(36) NOT NULL,
    CONSTRAINT "constraint_81" PRIMARY KEY ("client_id", "role_id"),
    CONSTRAINT "fk_ouse064plmlr732lxjcn1q5f1" FOREIGN KEY (client_id) REFERENCES client(id) NOT DEFERRABLE,
    CONSTRAINT "fk_p3rh9grku11kqfrs4fltt7rnq" FOREIGN KEY (role_id) REFERENCES keycloak_role(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_scope_mapping_role" ON "public"."scope_mapping" USING btree ("role_id");


CREATE TABLE "public"."scope_policy" (
    "scope_id" character varying(36) NOT NULL,
    "policy_id" character varying(36) NOT NULL,
    CONSTRAINT "constraint_farsrsps" PRIMARY KEY ("scope_id", "policy_id"),
    CONSTRAINT "fk_frsrasp13xcx4wnkog82ssrfy" FOREIGN KEY (policy_id) REFERENCES resource_server_policy(id) NOT DEFERRABLE,
    CONSTRAINT "fk_frsrpass3xcx4wnkog82ssrfy" FOREIGN KEY (scope_id) REFERENCES resource_server_scope(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_scope_policy_policy" ON "public"."scope_policy" USING btree ("policy_id");


CREATE TABLE "public"."user_attribute" (
    "name" character varying(255) NOT NULL,
    "value" character varying(255),
    "user_id" character varying(36) NOT NULL,
    "id" character varying(36) DEFAULT 'sybase-needs-something-here' NOT NULL,
    CONSTRAINT "constraint_user_attribute_pk" PRIMARY KEY ("id"),
    CONSTRAINT "fk_5hrm2vlf9ql5fu043kqepovbr" FOREIGN KEY (user_id) REFERENCES user_entity(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_user_attribute" ON "public"."user_attribute" USING btree ("user_id");


CREATE TABLE "public"."user_consent" (
    "id" character varying(36) NOT NULL,
    "client_id" character varying(255),
    "user_id" character varying(36) NOT NULL,
    "created_date" bigint,
    "last_updated_date" bigint,
    "client_storage_provider" character varying(36),
    "external_client_id" character varying(255),
    CONSTRAINT "constraint_grntcsnt_pm" PRIMARY KEY ("id"),
    CONSTRAINT "uk_jkuwuvd56ontgsuhogm8uewrt" UNIQUE ("client_id", "client_storage_provider", "external_client_id", "user_id"),
    CONSTRAINT "fk_grntcsnt_user" FOREIGN KEY (user_id) REFERENCES user_entity(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_user_consent" ON "public"."user_consent" USING btree ("user_id");


CREATE TABLE "public"."user_consent_client_scope" (
    "user_consent_id" character varying(36) NOT NULL,
    "scope_id" character varying(36) NOT NULL,
    CONSTRAINT "constraint_grntcsnt_clsc_pm" PRIMARY KEY ("user_consent_id", "scope_id"),
    CONSTRAINT "fk_grntcsnt_clsc_usc" FOREIGN KEY (user_consent_id) REFERENCES user_consent(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_usconsent_clscope" ON "public"."user_consent_client_scope" USING btree ("user_consent_id");


CREATE TABLE "public"."user_entity" (
    "id" character varying(36) NOT NULL,
    "email" character varying(255),
    "email_constraint" character varying(255),
    "email_verified" boolean DEFAULT false NOT NULL,
    "enabled" boolean DEFAULT false NOT NULL,
    "federation_link" character varying(255),
    "first_name" character varying(255),
    "last_name" character varying(255),
    "realm_id" character varying(255),
    "username" character varying(255),
    "created_timestamp" bigint,
    "service_account_client_link" character varying(255),
    "not_before" integer DEFAULT '0' NOT NULL,
    CONSTRAINT "constraint_fb" PRIMARY KEY ("id"),
    CONSTRAINT "uk_dykn684sl8up1crfei6eckhd7" UNIQUE ("realm_id", "email_constraint"),
    CONSTRAINT "uk_ru8tt6t700s9v50bu18ws5ha6" UNIQUE ("realm_id", "username")
) WITH (oids = false);

CREATE INDEX "idx_user_email" ON "public"."user_entity" USING btree ("email");


CREATE TABLE "public"."user_federation_config" (
    "user_federation_provider_id" character varying(36) NOT NULL,
    "value" character varying(255),
    "name" character varying(255) NOT NULL,
    CONSTRAINT "constraint_f9" PRIMARY KEY ("user_federation_provider_id", "name"),
    CONSTRAINT "fk_t13hpu1j94r2ebpekr39x5eu5" FOREIGN KEY (user_federation_provider_id) REFERENCES user_federation_provider(id) NOT DEFERRABLE
) WITH (oids = false);


CREATE TABLE "public"."user_federation_mapper" (
    "id" character varying(36) NOT NULL,
    "name" character varying(255) NOT NULL,
    "federation_provider_id" character varying(36) NOT NULL,
    "federation_mapper_type" character varying(255) NOT NULL,
    "realm_id" character varying(36) NOT NULL,
    CONSTRAINT "constraint_fedmapperpm" PRIMARY KEY ("id"),
    CONSTRAINT "fk_fedmapperpm_fedprv" FOREIGN KEY (federation_provider_id) REFERENCES user_federation_provider(id) NOT DEFERRABLE,
    CONSTRAINT "fk_fedmapperpm_realm" FOREIGN KEY (realm_id) REFERENCES realm(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_usr_fed_map_fed_prv" ON "public"."user_federation_mapper" USING btree ("federation_provider_id");

CREATE INDEX "idx_usr_fed_map_realm" ON "public"."user_federation_mapper" USING btree ("realm_id");


CREATE TABLE "public"."user_federation_mapper_config" (
    "user_federation_mapper_id" character varying(36) NOT NULL,
    "value" character varying(255),
    "name" character varying(255) NOT NULL,
    CONSTRAINT "constraint_fedmapper_cfg_pm" PRIMARY KEY ("user_federation_mapper_id", "name"),
    CONSTRAINT "fk_fedmapper_cfg" FOREIGN KEY (user_federation_mapper_id) REFERENCES user_federation_mapper(id) NOT DEFERRABLE
) WITH (oids = false);


CREATE TABLE "public"."user_federation_provider" (
    "id" character varying(36) NOT NULL,
    "changed_sync_period" integer,
    "display_name" character varying(255),
    "full_sync_period" integer,
    "last_sync" integer,
    "priority" integer,
    "provider_name" character varying(255),
    "realm_id" character varying(36),
    CONSTRAINT "constraint_5c" PRIMARY KEY ("id"),
    CONSTRAINT "fk_1fj32f6ptolw2qy60cd8n01e8" FOREIGN KEY (realm_id) REFERENCES realm(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_usr_fed_prv_realm" ON "public"."user_federation_provider" USING btree ("realm_id");


CREATE TABLE "public"."user_group_membership" (
    "group_id" character varying(36) NOT NULL,
    "user_id" character varying(36) NOT NULL,
    CONSTRAINT "constraint_user_group" PRIMARY KEY ("group_id", "user_id"),
    CONSTRAINT "fk_user_group_user" FOREIGN KEY (user_id) REFERENCES user_entity(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_user_group_mapping" ON "public"."user_group_membership" USING btree ("user_id");


CREATE TABLE "public"."user_required_action" (
    "user_id" character varying(36) NOT NULL,
    "required_action" character varying(255) DEFAULT ' ' NOT NULL,
    CONSTRAINT "constraint_required_action" PRIMARY KEY ("required_action", "user_id"),
    CONSTRAINT "fk_6qj3w1jw9cvafhe19bwsiuvmd" FOREIGN KEY (user_id) REFERENCES user_entity(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_user_reqactions" ON "public"."user_required_action" USING btree ("user_id");


CREATE TABLE "public"."user_role_mapping" (
    "role_id" character varying(255) NOT NULL,
    "user_id" character varying(36) NOT NULL,
    CONSTRAINT "constraint_c" PRIMARY KEY ("role_id", "user_id"),
    CONSTRAINT "fk_c4fqv34p1mbylloxang7b1q3l" FOREIGN KEY (user_id) REFERENCES user_entity(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_user_role_mapping" ON "public"."user_role_mapping" USING btree ("user_id");


CREATE TABLE "public"."user_session" (
    "id" character varying(36) NOT NULL,
    "auth_method" character varying(255),
    "ip_address" character varying(255),
    "last_session_refresh" integer,
    "login_username" character varying(255),
    "realm_id" character varying(255),
    "remember_me" boolean DEFAULT false NOT NULL,
    "started" integer,
    "user_id" character varying(255),
    "user_session_state" integer,
    "broker_session_id" character varying(255),
    "broker_user_id" character varying(255),
    CONSTRAINT "constraint_57" PRIMARY KEY ("id")
) WITH (oids = false);


CREATE TABLE "public"."user_session_note" (
    "user_session" character varying(36) NOT NULL,
    "name" character varying(255) NOT NULL,
    "value" character varying(2048),
    CONSTRAINT "constraint_usn_pk" PRIMARY KEY ("user_session", "name"),
    CONSTRAINT "fk5edfb00ff51d3472" FOREIGN KEY (user_session) REFERENCES user_session(id) NOT DEFERRABLE
) WITH (oids = false);


CREATE TABLE "public"."username_login_failure" (
    "realm_id" character varying(36) NOT NULL,
    "username" character varying(255) NOT NULL,
    "failed_login_not_before" integer,
    "last_failure" bigint,
    "last_ip_failure" character varying(255),
    "num_failures" integer,
    CONSTRAINT "CONSTRAINT_17-2" PRIMARY KEY ("realm_id", "username")
) WITH (oids = false);


CREATE TABLE "public"."web_origins" (
    "client_id" character varying(36) NOT NULL,
    "value" character varying(255) NOT NULL,
    CONSTRAINT "constraint_web_origins" PRIMARY KEY ("client_id", "value"),
    CONSTRAINT "fk_lojpho213xcx4wnkog82ssrfy" FOREIGN KEY (client_id) REFERENCES client(id) NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "idx_web_orig_client" ON "public"."web_origins" USING btree ("client_id");


-- 2020-06-06 17:12:30.287238+00
