--기본키,외래키 관계인 주종관계 테이블 생성
--먼저 기본키를 가진 주인테이블 생성
create table dept91(
 deptno number(38) constraint dept91_deptno_pk primary key  --부서번호
 ,dname varchar2(50) --부서명
 ,LOC varchar2(50) --부서지역
 );
 
 insert into dept91 values(10,'경리부','서울');
 insert into dept91 values(20,'영업부','부산');
 
 select * from dept91 order by deptno; --asc문이 생략됨.
 
 --외래키가 포함된 emp91 테이블 생성
 create table emp91(
  empno number(38) constraint emp91_empno_pk primary key
  ,ename varchar2(50) constraint emp91_ename_nn not null
  , job varchar2(50)
  ,deptno number(38) constraint emp91_deptno_fk
  references dept91(deptno) --외래키로 설정  
 );
 
 insert into emp91 values(11,'홍길동','경리부장',10);
 insert into emp91 values(12,'이순신','영업부장',20);

 select * from emp91;
 
 --외래키로 설정된 컬럼에 레코드가 있는 상태에서 주인키 부서번호 10번 삭제시도
 delete from dept91 where deptno=10; --참조 무결성 외래키 제약조건으로 설정된 컬럼에 10번 부서번호가 저장되어 있어서 삭제못함.
 
 --emp91테이블 외래키를 삭제하지 않고 잠시 비활성화
 alter table emp91 disable constraint emp91_deptno_fk;
 
 select constraint_name,status from user_constraints where table_name='EMP91';
 /* STATUS 컬럼값에서 DISABLED는 제약조건 비활성화, ENABLED는 제약조건 활성화
 */
 --제약조건 비활성화 된 상태에서 DEPT91테이블의 10번 부서번호 삭제
 DELETE from dept91 where deptno=10;
 
 select * from dept91;
 
 --emp91_deptno_fk 외래키 제약조건 활성화
 alter table emp91 enable constraint emp91_deptno_fk;
 
 insert into dept91 values(10,'경리부','서울');
 
 /* cascade 옵션을 사용하기 위한 주종관계 부모 와 자손테이블 생성
 */
 --기본키가 있는 부서테이블 생성)
 create table dept81(
   deptno number(38) constraint dept81_deptno_pk primary key --부서번호
   ,dname varchar2(50)
   ,LOC varchar2(50)
   );
   insert into dept81 values(101,'관리부','서울');
   insert into dept81 values(102,'개발부','여수');
   
   select * from dept81 order by deptno;
   
   --외래키가 있는 사원테이블 생성
   create table emp81(
    empno number(38) constraint emp81_empno_pk primary key
    ,ename varchar2(50) constraint emp81_ename_nn not null
    ,job varchar2(50)
    ,deptno number(38) constraint emp81_deptno_fk references dept81(deptno)
    );
    insert into emp81 values(7001,'이순신','관리사원',101);
    insert into emp81 values(7002,'강감찬','java개발자',102);
    
    select * from emp81;
    
    desc emp81;
    
    select constraint_name,constraint_type,table_name,R_constraint_name,status from user_constraints
    where table_name in('DEPT81','EMP81');
    
    /* CASCADE 옵션을 사용해서 dept81테이블의 기본키 제약조건을 비활성화 하면 emp81테이블의 외래키 제약조건까지 한꺼번에 
    비활성화된다.*/
    alter table dept81 disable primary key cascade;
    
    alter table dept81 drop primary key; --기본키와 외래키가 함께 비활성화 되어 있어도 기본키삭제 불가
    
    alter table dept81 drop primary key cascade; --cascade 옵션으로 기본키를 삭제하면 외래키까지 한꺼번에 삭제
    
    commit;
    