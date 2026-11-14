/*
# Enforce unique team names

1. Changes
- Adds a unique index on the team name so no two teams can share a name.
- Names are compared ignoring letter case and leading/trailing spaces, so "Sparks" and "  sparks " count as the same team.
- Team login now uses the same comparison, so a team can sign back in with any capitalisation of its name.

2. Security
- team_login keeps its existing security settings (runs with definer rights, fixed search path).

3. Notes
- If a registration reuses a taken name, the database rejects it and the app shows "That team name is already taken".
- The index creation is idempotent and safe to re-run.
*/

CREATE UNIQUE INDEX IF NOT EXISTS teams_name_unique_idx
  ON teams (lower(btrim(name)));

CREATE OR REPLACE FUNCTION team_login(p_name text, p_pin text)
RETURNS TABLE(team_id uuid, session_token text)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_team_id uuid;
  v_stored_pin text;
  v_stored_hash text;
BEGIN
  SELECT teams.id, teams.pin, teams.password_hash
  INTO v_team_id, v_stored_pin, v_stored_hash
  FROM teams
  WHERE lower(btrim(teams.name)) = lower(btrim(p_name));

  IF NOT FOUND THEN
    RETURN;
  END IF;

  IF v_stored_pin IS NOT NULL THEN
    IF v_stored_pin <> p_pin THEN
      RETURN;
    END IF;
  ELSIF v_stored_hash IS NOT NULL THEN
    IF v_stored_hash <> extensions.crypt(p_pin, v_stored_hash) THEN
      RETURN;
    END IF;
  ELSE
    RETURN;
  END IF;

  session_token := encode(extensions.gen_random_bytes(32), 'hex');
  INSERT INTO sessions (team_id, owner_type, owner_id, token, expires_at)
  VALUES (v_team_id, 'team', v_team_id, session_token, now() + interval '24 hours');

  RETURN QUERY SELECT v_team_id, session_token;
END;
$$;
