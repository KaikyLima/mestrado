; ModuleID = 'example-for-directive.c'
source_filename = "example-for-directive.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.ident_t = type { i32, i32, i32, i32, ptr }

@.str = private unnamed_addr constant [42 x i8] c"Thread[%d][%lu]: Before parallel region.\0A\00", align 1
@0 = private unnamed_addr constant [23 x i8] c";unknown;unknown;0;0;;\00", align 1
@1 = private unnamed_addr constant %struct.ident_t { i32 0, i32 514, i32 0, i32 22, ptr @0 }, align 8
@.str.1 = private unnamed_addr constant [49 x i8] c"Thread[%d][%lu]: Working in %lu loop iteration.\0A\00", align 1
@2 = private unnamed_addr constant %struct.ident_t { i32 0, i32 66, i32 0, i32 22, ptr @0 }, align 8
@3 = private unnamed_addr constant %struct.ident_t { i32 0, i32 2, i32 0, i32 22, ptr @0 }, align 8
@.str.2 = private unnamed_addr constant [43 x i8] c"Thread[%d][%lu]: After parallel region...\0A\00", align 1

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local i32 @main() #0 {
entry:
  %retval = alloca i32, align 4
  %id = alloca i32, align 4
  %i = alloca i32, align 4
  %0 = call i32 @__kmpc_global_thread_num(ptr @3)
  store i32 0, ptr %retval, align 4
  %call = call i32 @omp_get_thread_num()
  %call1 = call i64 @pthread_self() #6
  %call2 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef %call, i64 noundef %call1)
  call void @__kmpc_push_num_threads(ptr @3, i32 %0, i32 4)
  call void (ptr, i32, ptr, ...) @__kmpc_fork_call(ptr @3, i32 0, ptr @main.omp_outlined)
  %call3 = call i32 @omp_get_thread_num()
  %call4 = call i64 @pthread_self() #6
  %call5 = call i32 (ptr, ...) @printf(ptr noundef @.str.2, i32 noundef %call3, i64 noundef %call4)
  ret i32 0
}

declare i32 @printf(ptr noundef, ...) #1

declare i32 @omp_get_thread_num() #1

; Function Attrs: nounwind willreturn memory(none)
declare i64 @pthread_self() #2

; Function Attrs: noinline norecurse nounwind optnone sspstrong uwtable
define internal void @main.omp_outlined(ptr noalias noundef %.global_tid., ptr noalias noundef %.bound_tid.) #3 {
entry:
  %.global_tid..addr = alloca ptr, align 8
  %.bound_tid..addr = alloca ptr, align 8
  %id = alloca i32, align 4
  %.omp.iv = alloca i32, align 4
  %tmp = alloca i32, align 4
  %.omp.lb = alloca i32, align 4
  %.omp.ub = alloca i32, align 4
  %.omp.stride = alloca i32, align 4
  %.omp.is_last = alloca i32, align 4
  %i = alloca i32, align 4
  store ptr %.global_tid., ptr %.global_tid..addr, align 8
  store ptr %.bound_tid., ptr %.bound_tid..addr, align 8
  %call = call i32 @omp_get_thread_num()
  store i32 %call, ptr %id, align 4
  store i32 0, ptr %.omp.lb, align 4
  store i32 15, ptr %.omp.ub, align 4
  store i32 1, ptr %.omp.stride, align 4
  store i32 0, ptr %.omp.is_last, align 4
  %0 = load ptr, ptr %.global_tid..addr, align 8
  %1 = load i32, ptr %0, align 4
  call void @__kmpc_for_static_init_4(ptr @1, i32 %1, i32 34, ptr %.omp.is_last, ptr %.omp.lb, ptr %.omp.ub, ptr %.omp.stride, i32 1, i32 1)
  %2 = load i32, ptr %.omp.ub, align 4
  %cmp = icmp sgt i32 %2, 15
  br i1 %cmp, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  br label %cond.end

cond.false:                                       ; preds = %entry
  %3 = load i32, ptr %.omp.ub, align 4
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi i32 [ 15, %cond.true ], [ %3, %cond.false ]
  store i32 %cond, ptr %.omp.ub, align 4
  %4 = load i32, ptr %.omp.lb, align 4
  store i32 %4, ptr %.omp.iv, align 4
  br label %omp.inner.for.cond

omp.inner.for.cond:                               ; preds = %omp.inner.for.inc, %cond.end
  %5 = load i32, ptr %.omp.iv, align 4
  %6 = load i32, ptr %.omp.ub, align 4
  %cmp1 = icmp sle i32 %5, %6
  br i1 %cmp1, label %omp.inner.for.body, label %omp.inner.for.end

omp.inner.for.body:                               ; preds = %omp.inner.for.cond
  %7 = load i32, ptr %.omp.iv, align 4
  %mul = mul nsw i32 %7, 1
  %add = add nsw i32 0, %mul
  store i32 %add, ptr %i, align 4
  %8 = load i32, ptr %id, align 4
  %call2 = call i64 @pthread_self() #6
  %9 = load i32, ptr %i, align 4
  %call3 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef %8, i64 noundef %call2, i32 noundef %9)
  br label %omp.body.continue

omp.body.continue:                                ; preds = %omp.inner.for.body
  br label %omp.inner.for.inc

omp.inner.for.inc:                                ; preds = %omp.body.continue
  %10 = load i32, ptr %.omp.iv, align 4
  %add4 = add nsw i32 %10, 1
  store i32 %add4, ptr %.omp.iv, align 4
  br label %omp.inner.for.cond

omp.inner.for.end:                                ; preds = %omp.inner.for.cond
  br label %omp.loop.exit

omp.loop.exit:                                    ; preds = %omp.inner.for.end
  call void @__kmpc_for_static_fini(ptr @1, i32 %1)
  call void @__kmpc_barrier(ptr @2, i32 %1)
  ret void
}

; Function Attrs: nounwind
declare void @__kmpc_for_static_init_4(ptr, i32, i32, ptr, ptr, ptr, ptr, i32, i32) #4

; Function Attrs: nounwind
declare void @__kmpc_for_static_fini(ptr, i32) #4

; Function Attrs: convergent nounwind
declare void @__kmpc_barrier(ptr, i32) #5

; Function Attrs: nounwind
declare i32 @__kmpc_global_thread_num(ptr) #4

; Function Attrs: nounwind
declare void @__kmpc_push_num_threads(ptr, i32, i32) #4

; Function Attrs: nounwind
declare !callback !7 void @__kmpc_fork_call(ptr, i32, ptr, ...) #4

attributes #0 = { noinline nounwind optnone sspstrong uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind willreturn memory(none) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noinline norecurse nounwind optnone sspstrong uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }
attributes #5 = { convergent nounwind }
attributes #6 = { nounwind willreturn memory(none) }

!llvm.module.flags = !{!0, !1, !2, !3, !4, !5}
!llvm.ident = !{!6}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"openmp", i32 51}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"PIE Level", i32 2}
!4 = !{i32 7, !"uwtable", i32 2}
!5 = !{i32 7, !"frame-pointer", i32 2}
!6 = !{!"clang version 22.1.8"}
!7 = !{!8}
!8 = !{i64 2, i64 -1, i64 -1, i1 true}
