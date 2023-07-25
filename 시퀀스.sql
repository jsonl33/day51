--dept_deptno_seq 시퀀스 생성
create sequence dept_deptno_seq
start with 1 -- 1부터 시작
increment By 1 -- 1씩 증가
nocache; --임시 메모리를 사용 안함.

--현재 생성된 시퀀스 이름과 증가값 확인
select sequence_name, increment_by from user_sequences;
/* sequence_name컬럼에는 생성된 시퀀스 이름을 확인 가능하다.
   increment_by 컬럼에는 각 시퀀스의 증가값에 대한 정보를 저장하고 있다.
*/

--dept_deptno_seq 시퀀스 다음번호값 확인
select dept_deptno_seq.nextval as "시퀀스 번호값 확인" from dual;

/* 시퀀스를 실무 프로젝트에 적용하는 예)
     게시판번호,자료실번호,공지사항 번호등에 해당하는 컬럼에 적용한다. 이 컬럼에는 중복번호가 없고,null이 없는 primary key로 설정된
     컬럼이고 동시에 정수 숫자형으로 선언된 컬럼 레코드값 번호 저장용도로 사용된다.
*/

/* 시퀀스 삭제 문법형식)
   drop sequence 시퀀스명;
*/

--삭제할 시퀀스 생성
create sequence dept_del_seq;

select sequence_name from user_sequences; --생성된 시퀀스명 확인

--dept_del_seq 시퀀스 삭제
drop sequence dept_del_seq;

/* 시퀀스 수정 : alter sequence 문을 사용한다 . */
create sequence dept_test
start with 10 --10부터 시작
increment by 10 --10씩 증가
maxvalue 30; --시퀀스 최대값을 30으로 설정

select sequence_name, max_value, increment_by from user_sequences; --현재 생성된 시퀀스 이름,최대값,증가값 확인이 가능

select dept_test.nextval as "번호값01" from dual;
select dept_test.nextval as "번호값02" from dual;
select dept_test.nextval as "번호값03" from dual;
select dept_test.nextval as "번호값04" from dual; --해당 시퀀스 최대값 30을 초과해서 오류 발생.즉 최대값이 30인대 40을 발생해서 오류
--발생

--dept_test 시퀀스 최대값을 30에서 1000으로 수정
alter sequence dept_test 
maxvalue 1000;