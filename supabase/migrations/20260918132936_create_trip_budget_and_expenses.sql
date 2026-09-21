create table public.trip_budgets (
	id uuid primary key default gen_random_uuid(),
	trip_id uuid not null unique
		references public.trips(id)
		on delete cascade,
	amount_paise bigint not null
		check (amount_paise >= 0),
	currency text not null default 'INR'
		check (currency = 'INR'),
	created_at timestamptz not null default now(),
	updated_at timestamptz not null default now()
);

create table public.trip_expenses (
	id uuid primary key default gen_random_uuid(),
	trip_id uuid not null
		references public.trips(id)
		on delete cascade,
	title text not null
		check (length(trim(title)) > 0),
	amount_paise bigint not null
		check (amount_paise > 0),
	currency text not null default 'INR'
		check (currency = 'INR'),
	category text not null
		check (
			category in (
				'Accommodation',
				'Transport',
				'Food',
				'Activities',
				'Shopping',
				'Other'
			)
		),
	note text null,
	spent_at timestamptz not null,
	created_at timestamptz not null default now(),
	updated_at timestamptz not null default now()
);

create index trip_expenses_trip_spent_idx
	on public.trip_expenses (trip_id, spent_at desc, created_at desc);

alter table public.trip_budgets enable row level security;
alter table public.trip_expenses enable row level security;

grant select, insert, update, delete
on table public.trip_budgets
to authenticated;

grant select, insert, update, delete
on table public.trip_expenses
to authenticated;

create policy "Users can read budgets for their trips"
	on public.trip_budgets
	for select
	to authenticated
	using (
		exists (
			select 1
			from public.trips
			where public.trips.id = trip_budgets.trip_id
				and public.trips.user_id = auth.uid()
		)
	);

create policy "Users can insert budgets for their trips"
	on public.trip_budgets
	for insert
	to authenticated
	with check (
		exists (
			select 1
			from public.trips
			where public.trips.id = trip_budgets.trip_id
				and public.trips.user_id = auth.uid()
		)
	);

create policy "Users can update budgets for their trips"
	on public.trip_budgets
	for update
	to authenticated
	using (
		exists (
			select 1
			from public.trips
			where public.trips.id = trip_budgets.trip_id
				and public.trips.user_id = auth.uid()
		)
	)
	with check (
		exists (
			select 1
			from public.trips
			where public.trips.id = trip_budgets.trip_id
				and public.trips.user_id = auth.uid()
		)
	);

create policy "Users can delete budgets for their trips"
	on public.trip_budgets
	for delete
	to authenticated
	using (
		exists (
			select 1
			from public.trips
			where public.trips.id = trip_budgets.trip_id
				and public.trips.user_id = auth.uid()
		)
	);

create policy "Users can read expenses for their trips"
	on public.trip_expenses
	for select
	to authenticated
	using (
		exists (
			select 1
			from public.trips
			where public.trips.id = trip_expenses.trip_id
				and public.trips.user_id = auth.uid()
		)
	);

create policy "Users can insert expenses for their trips"
	on public.trip_expenses
	for insert
	to authenticated
	with check (
		exists (
			select 1
			from public.trips
			where public.trips.id = trip_expenses.trip_id
				and public.trips.user_id = auth.uid()
		)
	);

create policy "Users can update expenses for their trips"
	on public.trip_expenses
	for update
	to authenticated
	using (
		exists (
			select 1
			from public.trips
			where public.trips.id = trip_expenses.trip_id
				and public.trips.user_id = auth.uid()
		)
	)
	with check (
		exists (
			select 1
			from public.trips
			where public.trips.id = trip_expenses.trip_id
				and public.trips.user_id = auth.uid()
		)
	);

create policy "Users can delete expenses for their trips"
	on public.trip_expenses
	for delete
	to authenticated
	using (
		exists (
			select 1
			from public.trips
			where public.trips.id = trip_expenses.trip_id
				and public.trips.user_id = auth.uid()
		)
	);
