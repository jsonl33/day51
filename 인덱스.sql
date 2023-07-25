/*
  오라클에서 인덱스를 사용하는 목적: 보다 더 빠른 검색을 위해서 이다.
  테이블 생성시 기본키 또는 유일키 제약조건을 설정하면 오라클에서 해당 컬럼에 기본으로 인덱스를 생성해 준다.
*/
create table emp201(
 empno number(38) primary key
 ,ename varchar2(100)
 ,sal number(38)
 );
insert into emp201 values(11,'홍길동',100);
insert into emp201 values(12,'이순신',200);
insert into emp201 values(13,'강감찬',300);

select * from emp201;

--서브쿼리로 복제본 테이블 emp202을 생성
create table emp202
as
select * from emp201; --복제본 테이블 emp202에는 인덱스는 복제되지 않는다.

select table_name,index_name,column_name from user_ind_columns
where table_name in('EMP201','EMP202');
/* IDNEX_NAME컬럼에는 인덱스명이 저장되어 있고, emp201원본테이블의 기본키로 설정된 empno컬럼에만 오라클에서 제공한 기본
인덱스가 설정되어 있다. 결국 복제본 테이블에는 원본의 인덱스까지는 복제되지 않는다는 것을 알수 있다.
*/
select * from emp202; --emp202 복제테이블에는 원본테이블의 기본키 제약조건도 복제되지 않는다.

--서브쿼리로 중복사원번호 저장
insert into emp202
select * from emp202;

--emp202 복제테이블의 ename컬럼에 인덱스 설정
create index idx_emp202_ename
on emp202(ename);

--emp202 복제테이블의 empno컬럼에 인덱스 설정
create index idx_emp202_empno
on emp202(empno);

--emp202테이블에 생성된 idx_emp202_empno 인덱스를 삭제
drop index idx_emp202_empno;