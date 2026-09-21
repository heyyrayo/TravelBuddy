create table public.itinerary_items (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null
    references public.trips(id)
    on delete cascade,
  day_number integer not null
    check (day_number >= 1),
  title text not null,
  description text null,
  location text null,
  category text null,
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index itinerary_items_trip_day_order_idx
  on public.itinerary_items (trip_id, day_number, sort_order);

alter table public.itinerary_items enable row level security;

create policy "Users can read itinerary items for their trips"
  on public.itinerary_items
  for select
  to authenticated
  using (
    exists (
      select 1
      from public.trips
      where public.trips.id = itinerary_items.trip_id
        and public.trips.user_id = auth.uid()
    )
  );

create policy "Users can insert itinerary items for their trips"
  on public.itinerary_items
  for insert
  to authenticated
  with check (
    exists (
      select 1
      from public.trips
      where public.trips.id = itinerary_items.trip_id
        and public.trips.user_id = auth.uid()
    )
  );

create policy "Users can update itinerary items for their trips"
  on public.itinerary_items
  for update
  to authenticated
  using (
    exists (
      select 1
      from public.trips
      where public.trips.id = itinerary_items.trip_id
        and public.trips.user_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1
      from public.trips
      where public.trips.id = itinerary_items.trip_id
        and public.trips.user_id = auth.uid()
    )
  );

create policy "Users can delete itinerary items for their trips"
  on public.itinerary_items
  for delete
  to authenticated
  using (
    exists (
      select 1
      from public.trips
      where public.trips.id = itinerary_items.trip_id
        and public.trips.user_id = auth.uid()
    )
  );
