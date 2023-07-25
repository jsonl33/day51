select * from dept81;

--dept81_copy 복제본 테이블 생성
create table dept81_copy
as
select * from dept81;

select * from dept81_copy;

create table emp_copy(
    empno number(38) primary key,
    ename varchar2(100),
    job varchar2(100),
    sal int,
    comm int,
    deptno int
    );
    
    insert into emp_copy values(201,'홍길동','관리사원',100,10,101);
    insert into emp_copy values(202,'이순신','개발사원',200,20,102);
    
    select * from emp_copy order by empno asc;
    
    --emp_view30 가상테이블 뷰 생성
    create view emp_view30
    as
    select empno,ename,deptno from emp_copy where deptno=101;
    
    /* ORA-01031:권한 불충분 에러가 발생한다. 이것은 결국 해당 오라클 사용자로 가상테이블 뷰 생성권한이 없어서 발생한 것이다.
       에러 해결법: cmd를 실행해서 DBA 오라클 관리자 계정 중 하나인 system에 접근한다.
       SQL>grant create view to 사용자; 로 해당 사용자에게 뷰생성 권한을 할당하면 된다.
    */
    
    --가상테이블 뷰를 통한 실제 테이블 검색
    select * from emp_view30;
    
    select view_name,text from user_views;
    /* view_name 컬럼에는 생성된 뷰이름 확인 가능하다.
       text컬럼에는 뷰생성시 정의한 as문 다음의 서브쿼리문이 저장된다.
    */
    
    --뷰를 통해서 실제 테이블에 레코드를 저장
    insert into emp_view30 values(203,'강감찬',102);
    
    select * from emp_copy;
    
    /* 가상테이블 뷰를 사용하는 목적)
       1. 복잡한 쿼리문을 단순화 할 수 있다.
       2. 실제 테이블을 뷰를 통해서 숨길 수 있다. 즉 보안면에서 유리하다.
    */
    --기본키가 있는 부모 테이블  dept86을 생성
    create table dept86(
      deptno number(38) constraint dept86_deptno_pk  primary key --부서번호
      ,dname varchar2(200) constraint dept86_dname_nn not null --부서명
      ,LOC varchar2(50) --부서지역
    );
    insert into dept86 values(10,'영업부','서울');
    insert into dept86 values(20,'인사부','인천 송도');
    
    select * from dept86 order by deptno;
    
    --외래키가 있는 자손테이블 emp86을 생성
    create table emp86(
     empno number(38) constraint emp86_empno_pk primary key --사원번호
     ,ename varchar2(100) constraint emp86_ename_nn not null --사원명
     ,sal number(38) --급여
     ,job varchar2(100) --직종
     ,comm number(38) --보너스
     ,deptno number(38) constraint emp86_deptno_fk references dept86(deptno) --외래키가 설정된 부서번호
    );
    
    insert into emp86 values(101,'이순신',3000,'영업사원',300,10);
    insert into emp86 values(102,'강감찬',6000,'영업과장',600,10);
    insert into emp86 values(103,'홍길동',5000,'인사과장',0,20);
    
    --deptno 공통컬럼과 부서번호가 10인 경우 Equi 조인 검색
    select empno,ename,job,sal,comm,d.deptno,dname from dept86 d, emp86 e
    where d.deptno=e.deptno and e.deptno=10 order by empno asc;
    
    --복잡한 조인 쿼리문을 가상테이블 뷰를 통해서 단순화
    create view join_view
    as
    select empno,ename,job,sal,comm,d.deptno,dname from dept86 d, emp86 e
    where d.deptno=e.deptno and e.deptno=10 order by empno asc;
    
    --뷰를 통해서 조인검색해서 실제 조인문을 단순화 시킴.
    select * from join_view;
    
    --삭제할 del_view 가상테이블 뷰 생성
    create view del_view
    as
    select empno,ename from emp86;
    
    --생성된 뷰 확인
    select view_name from user_views;
    
    --del_view 가상테이블 삭제
    drop view del_view;
    
    --or replace 옵션 실습을 위한 뷰 생성
    create view re__view
    as
    select  empno,ename from emp86;
    
    --re_view 뷰를 통해서 사원번호와 사원명만 검색
    select * from re__view;
    
    --re__view 뷰에 sal추가 수정
    create or replace view re__view
    as
    select empno,ename,sal from emp86;
    
    --force옵션을 사용해서 기존테이블이 없어도 뷰를 생성한다.
    create or replace force view for_view
    as
    select empno,ename from abc;
    
    --생성된 뷰이름 확인
    select view_name from user_views;
    
    select * from emp86;
    
    --with check option실습
    create or replace view view_check
    as
    select empno,ename,deptno from emp86 where deptno=20 with check option;
    
    select * from view_check;
    
    update view_check
    set deptno=10 where empno=103;
    /* 20번 부서번호는 뷰 생성시 with check option을 사용해서 뷰를 통한 20번 부서번호 수정못한다.
    */
    
    --with read only 옵션을 사용한 뷰 생성
    create or replace view only_view
    as
    select empno,ename,sal,comm,deptno 
    from emp86 where deptno=20 with read only;
    
    select * from only_view;
    
    update only_view set comm=500 where empno=103; --only_view는 단지 읽기만 가능한 뷰이기 때문에 보너스 컬럼 자료 수정못함.
    
    -- rowNum 컬럼 실습을 위한 테이블 생성
    create table emp92(
     empno number(38) primary key
     , ename varchar2(100)
     , sal int
     );
    insert into emp92 values(1,'홍길동',1000);
    insert into emp92 values(2,'이순신',2000);
    insert into emp92 values(3,'강감찬',3000);
    
    select rowNum , empno,ename,sal from emp92 order by empno asc;
    select rowNum , empno, ename, sal from emp92 order by empno desc;
    
    --저장 공간이 필요 없는 가상테이블 뷰를 사용해서 rowNum컬럼 순번을 변경
    create or replace view row_view
    as
    select empno,ename,sal from emp92 order by empno desc;
    
    select rowNum,empno,ename,sal from row_VIEW;
    
    delete from emp92 where empno=2;
    
    /* 문제) rowNum컬럼과 가상테이블 뷰인 row_view를 사용해서 가장 최근에 입사한 사원을 검색해 봅니다.  */
    select rownum,empno,ename,sal from row_view where rownum <= 1;
    
    --인라인 서브쿼리문을 활용해서 가장 최근에 입사한 사원을 구해본다.
    select rownum, empno, ename, sal
    from (select empno,ename,sal from emp92 order by empno desc)
    where rownum <= 1;