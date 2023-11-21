# SQL Assignment #02
# Muhammad Arslan Iftikhar

alter table petowners add primary key (OwnerID);
alter table pets add primary key (PetID(10));
set sql_safe_updates=0; 

select * from petowners;  select * from pets;
select * from proceduresdetails;  select * from procedureshistory;

# Q.No #01: . List the names of all pet owners along with the names of their pets. 
 SELECT o.name,o.Surname, p.name from petowners o join pets p on o.OwnerID = p.OwnerID;
 
# Q.No #02: List all pets and their owner names, including pets that don't have recorded  owners.
 select p.name, o.name
from pets p
left join petowners o on p.OwnerID = o.OwnerID;

# Q.No #03: Combine the information of pets and their owners, including those pets  without owners and owners without pets.  
select p.name, o.name
from pets p
left join petowners o on p.OwnerID = o.OwnerID

union

select p.name, o.name
from pets p
right join petowners o on p.OwnerID = o.OwnerID;

# Q.No #04: Find the names of pets along with their owners' names and the details of the  procedures they have undergone.  
select p.name PetName, o.name OwnerName, ph.ProcedureType ProcedureDetail
from pets p
left join petowners o on p.OwnerID = o.OwnerID
left join procedureshistory ph on p.PetID = ph.PetID;

# Q.No #05: List all pet owners and the number of dogs they own.  
select o.name, COUNT(p.PetID) AS dog_count
from petowners o
left join pets p on o.OwnerID = p.OwnerID
where p.kind = 'Dog'
group by o.name;

# Q.No #06: Identify pets that have not had any procedures.  
select p.PetID, p.name
from pets p
left join procedureshistory ph on p.PetID = ph.PetID
where ph.PetID is null;

# Q.No #07: Find the name of the oldest pet.
select name
from pets
order by  age desc
limit 1;

# Q.No #08: List all pets who had procedures that cost more than the average cost of all  procedures.  
select p.name, pd.price 
from pets p 
left join procedureshistory ph on p.PetID=ph.PetID
left join proceduresdetails pd on ph.ProcedureType=pd.ProcedureType
where pd.Price > (select avg(pd.Price) from proceduresdetails pd);

# Q.No #09: Find the details of procedures performed on 'Cuddles'.
SELECT p.name, ph.ProcedureType, pd.Price
FROM pets p
JOIN procedureshistory ph ON p.PetID = ph.PetID
join proceduresdetails pd on ph.ProcedureSubCode=pd.ProcedureSubCode
WHERE p.name = 'Cuddles';

/* Q.No #010: Create a list of pet owners along with the total cost they have spent on  procedures 
and display only those who have spent above the average  spending.  */
select o.name, SUM(pd.Price) AS total_spending
from petowners o
left join pets p on o.OwnerID=p.OwnerID
left join procedureshistory ph on p.PetID=ph.PetID
left join proceduresdetails pd on ph.ProcedureType=pd.ProcedureType
group by o.Name
having total_spending  > (select avg(pd.Price) from proceduresdetails pd);

# Q.No #011: List the pets who have undergone a procedure called 'VACCINATIONS'.
select p.name,ph.ProcedureType
from pets p
join procedureshistory ph on p.PetID = ph.PetID
WHERE ph.ProcedureType = 'VACCINATIONS';

# Q.No #012: Find the owners of pets who have had a procedure called 'EMERGENCY'.
select o.OwnerID,o.Name
from petowners o
left join pets p on o.OwnerID=p.OwnerID
left join procedureshistory ph on p.PetID=ph.PetID
left join proceduresdetails pd on ph.ProcedureType=pd.ProcedureType
where pd.Description = 'emergency';

# Q.No #013: Calculate the total cost spent by each pet owner on procedures.  
select o.name,sum(pd.Price) AS total_spending
from petowners o
left join pets p on o.OwnerID=p.OwnerID
left join procedureshistory ph on p.PetID=ph.PetID
left join proceduresdetails pd on ph.ProcedureType=pd.ProcedureType
group by o.Name
having total_spending is not null;

# Q.No #014: Count the number of pets of each kind.
select name,kind, count(kind) as kind_count
from pets
group by name, kind;

# Q.No #015: Group pets by their kind and gender and count the number of pets in each  group.
select Kind, Gender, count(*) as pet_count
from pets
group by kind, Gender;

# Q.No #016: Show the average age of pets for each kind, but only for kinds that have more  than 5 pets. 
select kind, avg(age) as avg_age
from pets
group by kind
having count(*) > 5;

# Q.No #017: Find the types of procedures that have an average cost greater than $50.
select procedureType,avg(Price)
from proceduresdetails
group by ProcedureType
having avg(Price) > 50;

/* Q.No #018: Classify pets as 'Young', 'Adult', or 'Senior' based on their age. 
Age less then  3 Young, Age between 3and 8 Adult, else Senior. */
select name,
       case
           when age < 3 then 'Young'
           when age >= 3 and age <= 8 then 'Adult'
           else 'Senior'
       end as age_group
from pets;

/* Q.No #019: Calculate the total spending of each pet owner on procedures, labeling them  as 'Low Spender' for spending under $100, 
'Moderate Spender' for spending  between $100 and $500, and 'High Spender' for spending over $500. */
select o.name,
       sum(pd.price) as total_spending,
       case
           when sum(pd.price) < 100 then 'Low Spender'
           when sum(pd.price) >= 100 and sum(pd.price) <= 500 then 'Moderate Spender'
           else 'High Spender'
       end as spending_label
from petowners o
left join pets p on o.OwnerID=p.OwnerID
left join procedureshistory ph on p.PetID=ph.PetID
left join proceduresdetails pd on ph.ProcedureType=pd.ProcedureType
group by o.name
having min(Price) is not null;

# Q.No #020: Show the gender of pets with a custom label ('Boy' for male, 'Girl' for female).
select name,
       case
           when gender = 'Male' then 'Boy'
           when gender = 'Female' then 'Girl'
           else 'Unknown'
       end as gender_label
from pets;

/* Q.No #021: For each pet, display the pet's name, the number of procedures they've had,  and a status label: 
'Regular' for pets with 1 to 3 procedures, 'Frequent' for 4 to  7 procedures, and 'Super User' for more than 7 procedures. */
select p.name,
       count(ph.ProcedureType) as procedure_count,
       case
           when count(*) between 1 and 3 then 'Regular'
           when count(*) between 4 and 7 then 'Frequent'
           else 'Super User'
       end as status_label
from pets p
join procedureshistory ph on p.PetID = ph.PetID
group by p.PetID;

# Q.No #022: Rank pets by age within each kind.  
select name, kind, age,
       rank() over (partition by kind order by age) as age_rank
from pets;

# Q.No #023: Assign a dense rank to pets based on their age, regardless of kind.
select name, kind, age,
       dense_rank() over (order by age) as age_rank
from pets;

# Q.No #024: For each pet, show the name of the next and previous pet in alphabetical order.
select name,
       (select max(name) from pets where name < p.name) as previous_pet,
       (select min(name) from pets where name > p.name) as next_pet
from pets p;

# Q.No #025: Show the average age of pets, partitioned by their kind.  
select kind, avg(age) as average_age
from pets
group by kind;

# Q.No #026: Create a CTE that lists all pets, then select pets older than 5 years from the  CTE. 
with all_pets as (
  select *
  from pets
)
select *
from all_pets
where age > 5;