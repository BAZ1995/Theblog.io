-- Drop the existing restrictive INSERT policy
DROP POLICY IF EXISTS "Authenticated users can create comments" ON public.comments;

-- Create a new policy that allows both authenticated and anonymous comments
CREATE POLICY "Anyone can create comments"
ON public.comments
FOR INSERT
WITH CHECK (
  -- Either: authenticated user setting their own user_id
  (auth.uid() IS NOT NULL AND user_id = auth.uid())
  OR
  -- Or: anonymous comment with NULL user_id
  (user_id IS NULL)
);