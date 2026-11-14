/*
# Riddle Trap: wrong-answer count and paid hints

1. Modified Tables
- `riddle_traps`
  - New column `wrong_attempts` (integer, default 0): how many wrong answers the target team has given for this riddle.
  - New column `hint_purchased` (boolean, default false): whether the target team has paid to unlock the hint for this riddle.

2. Security
- No change to access. The table stays server-only; riddle answers and hint text are never stored here.

3. Notes
- Existing trap rows start at 0 wrong attempts and no purchased hint.
- Both statements use IF NOT EXISTS, so the migration is safe to re-run.
*/

ALTER TABLE riddle_traps ADD COLUMN IF NOT EXISTS wrong_attempts integer NOT NULL DEFAULT 0;
ALTER TABLE riddle_traps ADD COLUMN IF NOT EXISTS hint_purchased boolean NOT NULL DEFAULT false;
