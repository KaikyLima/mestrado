; ModuleID = 'vectoradd-omp-for.c'
source_filename = "vectoradd-omp-for.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.ident_t = type { i32, i32, i32, i32, ptr }

@h_a = dso_local global ptr null, align 8
@h_b = dso_local global ptr null, align 8
@h_c = dso_local global ptr null, align 8
@partition = dso_local global i32 0, align 4
@stdout = external global ptr, align 8
@.str = private unnamed_addr constant [39 x i8] c"Thread[%lu]: Initializing the arrays.\0A\00", align 1
@.str.1 = private unnamed_addr constant [29 x i8] c"Thread[%lu]: h_c[%07d]: %f.\0A\00", align 1
@.str.2 = private unnamed_addr constant [24 x i8] c"Thread[%lu]: Checking.\0A\00", align 1
@.str.3 = private unnamed_addr constant [38 x i8] c"Thread[%lu]: Final Result: (%f, %f).\0A\00", align 1
@stderr = external global ptr, align 8
@.str.4 = private unnamed_addr constant [55 x i8] c"Uso: %s <num_elements> <num_threads> <partition_size>\0A\00", align 1
@.str.5 = private unnamed_addr constant [48 x i8] c"Thread[%lu]: num_elements: %d num_threads: %d.\0A\00", align 1
@.str.6 = private unnamed_addr constant [37 x i8] c"Thread[%lu]: Allocating the arrays.\0A\00", align 1
@.str.7 = private unnamed_addr constant [38 x i8] c"Thread[%lu]: Before parallel region.\0A\00", align 1
@0 = private unnamed_addr constant [23 x i8] c";unknown;unknown;0;0;;\00", align 1
@1 = private unnamed_addr constant %struct.ident_t { i32 0, i32 2, i32 0, i32 22, ptr @0 }, align 8
@.str.8 = private unnamed_addr constant [43 x i8] c"   Thread[%lu,%lu]: Working on partition.\0A\00", align 1
@2 = private unnamed_addr constant %struct.ident_t { i32 0, i32 66, i32 0, i32 22, ptr @0 }, align 8
@.str.9 = private unnamed_addr constant [25 x i8] c"  Thread[%lu]: Exiting.\0A\00", align 1
@.str.10 = private unnamed_addr constant [41 x i8] c"Thread[%lu]: All threads were finished.\0A\00", align 1
@.str.11 = private unnamed_addr constant [35 x i8] c"Thread[%lu]: Printing the result.\0A\00", align 1
@.str.12 = private unnamed_addr constant [35 x i8] c"Thread[%lu]: Checking the result.\0A\00", align 1
@.str.13 = private unnamed_addr constant [26 x i8] c"Thread[%lu]: Fui, Tchau!\0A\00", align 1

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local void @init_array(i32 noundef %n) #0 {
entry:
  %n.addr = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 %n, ptr %n.addr, align 4
  %0 = load ptr, ptr @stdout, align 8
  %call = call i64 @pthread_self() #10
  %call1 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %0, ptr noundef @.str, i64 noundef %call) #8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %1 = load i32, ptr %i, align 4
  %2 = load i32, ptr %n.addr, align 4
  %cmp = icmp slt i32 %1, %2
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %3 = load ptr, ptr @h_a, align 8
  %4 = load i32, ptr %i, align 4
  %idxprom = sext i32 %4 to i64
  %arrayidx = getelementptr inbounds float, ptr %3, i64 %idxprom
  store float 5.000000e-01, ptr %arrayidx, align 4
  %5 = load ptr, ptr @h_b, align 8
  %6 = load i32, ptr %i, align 4
  %idxprom2 = sext i32 %6 to i64
  %arrayidx3 = getelementptr inbounds float, ptr %5, i64 %idxprom2
  store float 5.000000e-01, ptr %arrayidx3, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %7 = load i32, ptr %i, align 4
  %inc = add nsw i32 %7, 1
  store i32 %inc, ptr %i, align 4
  br label %for.cond, !llvm.loop !7

for.end:                                          ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind
declare i32 @fprintf(ptr noundef, ptr noundef, ...) #1

; Function Attrs: nounwind willreturn memory(none)
declare i64 @pthread_self() #2

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local void @print_array(i32 noundef %n) #0 {
entry:
  %n.addr = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 %n, ptr %n.addr, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, ptr %i, align 4
  %1 = load i32, ptr %n.addr, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %2 = load ptr, ptr @stdout, align 8
  %call = call i64 @pthread_self() #10
  %3 = load i32, ptr %i, align 4
  %4 = load ptr, ptr @h_c, align 8
  %5 = load i32, ptr %i, align 4
  %idxprom = sext i32 %5 to i64
  %arrayidx = getelementptr inbounds float, ptr %4, i64 %idxprom
  %6 = load float, ptr %arrayidx, align 4
  %conv = fpext float %6 to double
  %call1 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %2, ptr noundef @.str.1, i64 noundef %call, i32 noundef %3, double noundef %conv) #8
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %7 = load i32, ptr %i, align 4
  %inc = add nsw i32 %7, 1
  store i32 %inc, ptr %i, align 4
  br label %for.cond, !llvm.loop !9

for.end:                                          ; preds = %for.cond
  ret void
}

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local void @check_result(i32 noundef %n) #0 {
entry:
  %n.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %sum = alloca float, align 4
  store i32 %n, ptr %n.addr, align 4
  store float 0.000000e+00, ptr %sum, align 4
  %0 = load ptr, ptr @stdout, align 8
  %call = call i64 @pthread_self() #10
  %call1 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %0, ptr noundef @.str.2, i64 noundef %call) #8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %1 = load i32, ptr %i, align 4
  %2 = load i32, ptr %n.addr, align 4
  %cmp = icmp slt i32 %1, %2
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %3 = load ptr, ptr @h_c, align 8
  %4 = load i32, ptr %i, align 4
  %idxprom = sext i32 %4 to i64
  %arrayidx = getelementptr inbounds float, ptr %3, i64 %idxprom
  %5 = load float, ptr %arrayidx, align 4
  %6 = load float, ptr %sum, align 4
  %add = fadd float %6, %5
  store float %add, ptr %sum, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %7 = load i32, ptr %i, align 4
  %inc = add nsw i32 %7, 1
  store i32 %inc, ptr %i, align 4
  br label %for.cond, !llvm.loop !10

for.end:                                          ; preds = %for.cond
  %8 = load ptr, ptr @stdout, align 8
  %call2 = call i64 @pthread_self() #10
  %9 = load float, ptr %sum, align 4
  %conv = fpext float %9 to double
  %10 = load float, ptr %sum, align 4
  %11 = load i32, ptr %n.addr, align 4
  %conv3 = sitofp i32 %11 to float
  %div = fdiv float %10, %conv3
  %conv4 = fpext float %div to double
  %call5 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %8, ptr noundef @.str.3, i64 noundef %call2, double noundef %conv, double noundef %conv4) #8
  ret void
}

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local i32 @main(i32 noundef %argc, ptr noundef %argv) #0 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca ptr, align 8
  %i = alloca i32, align 4
  %num_elements = alloca i32, align 4
  %num_threads = alloca i32, align 4
  %id = alloca i64, align 8
  %0 = call i32 @__kmpc_global_thread_num(ptr @1)
  store i32 0, ptr %retval, align 4
  store i32 %argc, ptr %argc.addr, align 4
  store ptr %argv, ptr %argv.addr, align 8
  store i32 0, ptr %num_threads, align 4
  %1 = load i32, ptr %argc.addr, align 4
  %cmp = icmp slt i32 %1, 4
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %2 = load ptr, ptr @stderr, align 8
  %3 = load ptr, ptr %argv.addr, align 8
  %arrayidx = getelementptr inbounds ptr, ptr %3, i64 0
  %4 = load ptr, ptr %arrayidx, align 8
  %call = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %2, ptr noundef @.str.4, ptr noundef %4) #8
  call void @exit(i32 noundef 0) #11
  unreachable

if.end:                                           ; preds = %entry
  %5 = load ptr, ptr %argv.addr, align 8
  %arrayidx1 = getelementptr inbounds ptr, ptr %5, i64 1
  %6 = load ptr, ptr %arrayidx1, align 8
  %call2 = call i32 @atoi(ptr noundef %6) #12
  store i32 %call2, ptr %num_elements, align 4
  %7 = load ptr, ptr %argv.addr, align 8
  %arrayidx3 = getelementptr inbounds ptr, ptr %7, i64 2
  %8 = load ptr, ptr %arrayidx3, align 8
  %call4 = call i32 @atoi(ptr noundef %8) #12
  store i32 %call4, ptr %num_threads, align 4
  %9 = load ptr, ptr %argv.addr, align 8
  %arrayidx5 = getelementptr inbounds ptr, ptr %9, i64 3
  %10 = load ptr, ptr %arrayidx5, align 8
  %call6 = call i32 @atoi(ptr noundef %10) #12
  store i32 %call6, ptr @partition, align 4
  %11 = load ptr, ptr @stdout, align 8
  %call7 = call i64 @pthread_self() #10
  %12 = load i32, ptr %num_elements, align 4
  %13 = load i32, ptr %num_threads, align 4
  %call8 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %11, ptr noundef @.str.5, i64 noundef %call7, i32 noundef %12, i32 noundef %13) #8
  %14 = load ptr, ptr @stdout, align 8
  %call9 = call i64 @pthread_self() #10
  %call10 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %14, ptr noundef @.str.6, i64 noundef %call9) #8
  %15 = load i32, ptr %num_elements, align 4
  %conv = sext i32 %15 to i64
  %mul = mul i64 %conv, 4
  %call11 = call noalias ptr @malloc(i64 noundef %mul) #13
  store ptr %call11, ptr @h_a, align 8
  %16 = load i32, ptr %num_elements, align 4
  %conv12 = sext i32 %16 to i64
  %mul13 = mul i64 %conv12, 4
  %call14 = call noalias ptr @malloc(i64 noundef %mul13) #13
  store ptr %call14, ptr @h_b, align 8
  %17 = load i32, ptr %num_elements, align 4
  %conv15 = sext i32 %17 to i64
  %mul16 = mul i64 %conv15, 4
  %call17 = call noalias ptr @malloc(i64 noundef %mul16) #13
  store ptr %call17, ptr @h_c, align 8
  %18 = load i32, ptr %num_elements, align 4
  call void @init_array(i32 noundef %18)
  %19 = load ptr, ptr @stdout, align 8
  %call18 = call i64 @pthread_self() #10
  %call19 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %19, ptr noundef @.str.7, i64 noundef %call18) #8
  %20 = load i32, ptr %num_threads, align 4
  call void @__kmpc_push_num_threads(ptr @1, i32 %0, i32 %20)
  call void (ptr, i32, ptr, ...) @__kmpc_fork_call(ptr @1, i32 1, ptr @main.omp_outlined, ptr %num_elements)
  %21 = load ptr, ptr @stdout, align 8
  %call20 = call i64 @pthread_self() #10
  %call21 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %21, ptr noundef @.str.10, i64 noundef %call20) #8
  %22 = load ptr, ptr @stdout, align 8
  %call22 = call i64 @pthread_self() #10
  %call23 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %22, ptr noundef @.str.11, i64 noundef %call22) #8
  %23 = load ptr, ptr @stdout, align 8
  %call24 = call i64 @pthread_self() #10
  %call25 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %23, ptr noundef @.str.12, i64 noundef %call24) #8
  %24 = load i32, ptr %num_elements, align 4
  call void @check_result(i32 noundef %24)
  %25 = load ptr, ptr @stdout, align 8
  %call26 = call i64 @pthread_self() #10
  %call27 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %25, ptr noundef @.str.13, i64 noundef %call26) #8
  ret i32 0
}

; Function Attrs: noreturn nounwind
declare void @exit(i32 noundef) #3

; Function Attrs: nounwind willreturn memory(read)
declare i32 @atoi(ptr noundef) #4

; Function Attrs: nounwind allocsize(0)
declare noalias ptr @malloc(i64 noundef) #5

; Function Attrs: noinline norecurse nounwind optnone sspstrong uwtable
define internal void @main.omp_outlined(ptr noalias noundef %.global_tid., ptr noalias noundef %.bound_tid., ptr noundef nonnull align 4 dereferenceable(4) %num_elements) #6 {
entry:
  %.global_tid..addr = alloca ptr, align 8
  %.bound_tid..addr = alloca ptr, align 8
  %num_elements.addr = alloca ptr, align 8
  %i = alloca i32, align 4
  %id = alloca i64, align 8
  %.omp.iv = alloca i32, align 4
  %tmp = alloca i32, align 4
  %.capture_expr. = alloca i32, align 4
  %.capture_expr.1 = alloca i32, align 4
  %i3 = alloca i32, align 4
  %.omp.lb = alloca i32, align 4
  %.omp.ub = alloca i32, align 4
  %.omp.stride = alloca i32, align 4
  %.omp.is_last = alloca i32, align 4
  %i5 = alloca i32, align 4
  store ptr %.global_tid., ptr %.global_tid..addr, align 8
  store ptr %.bound_tid., ptr %.bound_tid..addr, align 8
  store ptr %num_elements, ptr %num_elements.addr, align 8
  %0 = load ptr, ptr %num_elements.addr, align 8, !nonnull !11, !align !12
  %call = call i32 @omp_get_thread_num()
  %conv = sext i32 %call to i64
  store i64 %conv, ptr %id, align 8
  %1 = load i32, ptr %0, align 4
  store i32 %1, ptr %.capture_expr., align 4
  %2 = load i32, ptr %.capture_expr., align 4
  %sub = sub nsw i32 %2, 0
  %div = sdiv i32 %sub, 1
  %sub2 = sub nsw i32 %div, 1
  store i32 %sub2, ptr %.capture_expr.1, align 4
  store i32 0, ptr %i3, align 4
  %3 = load i32, ptr %.capture_expr., align 4
  %cmp = icmp slt i32 0, %3
  br i1 %cmp, label %omp.precond.then, label %omp.precond.end

omp.precond.then:                                 ; preds = %entry
  store i32 0, ptr %.omp.lb, align 4
  %4 = load i32, ptr %.capture_expr.1, align 4
  store i32 %4, ptr %.omp.ub, align 4
  store i32 1, ptr %.omp.stride, align 4
  store i32 0, ptr %.omp.is_last, align 4
  %5 = load i32, ptr @partition, align 4
  %6 = load i32, ptr %.capture_expr.1, align 4
  %7 = load ptr, ptr %.global_tid..addr, align 8
  %8 = load i32, ptr %7, align 4
  call void @__kmpc_dispatch_init_4(ptr @1, i32 %8, i32 1073741859, i32 0, i32 %6, i32 1, i32 %5)
  br label %omp.dispatch.cond

omp.dispatch.cond:                                ; preds = %omp.dispatch.inc, %omp.precond.then
  %9 = load ptr, ptr %.global_tid..addr, align 8
  %10 = load i32, ptr %9, align 4
  %11 = call i32 @__kmpc_dispatch_next_4(ptr @1, i32 %10, ptr %.omp.is_last, ptr %.omp.lb, ptr %.omp.ub, ptr %.omp.stride)
  %tobool = icmp ne i32 %11, 0
  br i1 %tobool, label %omp.dispatch.body, label %omp.dispatch.end

omp.dispatch.body:                                ; preds = %omp.dispatch.cond
  %12 = load i32, ptr %.omp.lb, align 4
  store i32 %12, ptr %.omp.iv, align 4
  br label %omp.inner.for.cond

omp.inner.for.cond:                               ; preds = %omp.inner.for.inc, %omp.dispatch.body
  %13 = load i32, ptr %.omp.iv, align 4, !llvm.access.group !13
  %14 = load i32, ptr %.omp.ub, align 4, !llvm.access.group !13
  %cmp6 = icmp sle i32 %13, %14
  br i1 %cmp6, label %omp.inner.for.body, label %omp.inner.for.end

omp.inner.for.body:                               ; preds = %omp.inner.for.cond
  %15 = load i32, ptr %.omp.iv, align 4, !llvm.access.group !13
  %mul = mul nsw i32 %15, 1
  %add = add nsw i32 0, %mul
  store i32 %add, ptr %i5, align 4, !llvm.access.group !13
  %16 = load ptr, ptr @stdout, align 8, !llvm.access.group !13
  %17 = load i64, ptr %id, align 8, !llvm.access.group !13
  %call8 = call i64 @pthread_self() #10
  %call9 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %16, ptr noundef @.str.8, i64 noundef %17, i64 noundef %call8) #8, !llvm.access.group !13
  %18 = load ptr, ptr @h_a, align 8, !llvm.access.group !13
  %19 = load i32, ptr %i5, align 4, !llvm.access.group !13
  %idxprom = sext i32 %19 to i64
  %arrayidx = getelementptr inbounds float, ptr %18, i64 %idxprom
  %20 = load float, ptr %arrayidx, align 4, !llvm.access.group !13
  %21 = load ptr, ptr @h_b, align 8, !llvm.access.group !13
  %22 = load i32, ptr %i5, align 4, !llvm.access.group !13
  %idxprom10 = sext i32 %22 to i64
  %arrayidx11 = getelementptr inbounds float, ptr %21, i64 %idxprom10
  %23 = load float, ptr %arrayidx11, align 4, !llvm.access.group !13
  %add12 = fadd float %20, %23
  %24 = load ptr, ptr @h_c, align 8, !llvm.access.group !13
  %25 = load i32, ptr %i5, align 4, !llvm.access.group !13
  %idxprom13 = sext i32 %25 to i64
  %arrayidx14 = getelementptr inbounds float, ptr %24, i64 %idxprom13
  store float %add12, ptr %arrayidx14, align 4, !llvm.access.group !13
  br label %omp.body.continue

omp.body.continue:                                ; preds = %omp.inner.for.body
  br label %omp.inner.for.inc

omp.inner.for.inc:                                ; preds = %omp.body.continue
  %26 = load i32, ptr %.omp.iv, align 4, !llvm.access.group !13
  %add15 = add nsw i32 %26, 1
  store i32 %add15, ptr %.omp.iv, align 4, !llvm.access.group !13
  br label %omp.inner.for.cond, !llvm.loop !14

omp.inner.for.end:                                ; preds = %omp.inner.for.cond
  br label %omp.dispatch.inc

omp.dispatch.inc:                                 ; preds = %omp.inner.for.end
  br label %omp.dispatch.cond

omp.dispatch.end:                                 ; preds = %omp.dispatch.cond
  %27 = load ptr, ptr %.global_tid..addr, align 8
  %28 = load i32, ptr %27, align 4
  call void @__kmpc_dispatch_deinit(ptr @1, i32 %28)
  br label %omp.precond.end

omp.precond.end:                                  ; preds = %omp.dispatch.end, %entry
  %29 = load ptr, ptr %.global_tid..addr, align 8
  %30 = load i32, ptr %29, align 4
  call void @__kmpc_barrier(ptr @2, i32 %30)
  %31 = load ptr, ptr @stdout, align 8
  %call16 = call i64 @pthread_self() #10
  %call17 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %31, ptr noundef @.str.9, i64 noundef %call16) #8
  ret void
}

declare i32 @omp_get_thread_num() #7

; Function Attrs: nounwind
declare void @__kmpc_dispatch_init_4(ptr, i32, i32, i32, i32, i32, i32) #8

; Function Attrs: nounwind
declare i32 @__kmpc_dispatch_next_4(ptr, i32, ptr, ptr, ptr, ptr) #8

; Function Attrs: nounwind
declare void @__kmpc_dispatch_deinit(ptr, i32) #8

; Function Attrs: convergent nounwind
declare void @__kmpc_barrier(ptr, i32) #9

; Function Attrs: nounwind
declare i32 @__kmpc_global_thread_num(ptr) #8

; Function Attrs: nounwind
declare void @__kmpc_push_num_threads(ptr, i32, i32) #8

; Function Attrs: nounwind
declare !callback !16 void @__kmpc_fork_call(ptr, i32, ptr, ...) #8

attributes #0 = { noinline nounwind optnone sspstrong uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind willreturn memory(none) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind willreturn memory(read) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { noinline norecurse nounwind optnone sspstrong uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #8 = { nounwind }
attributes #9 = { convergent nounwind }
attributes #10 = { nounwind willreturn memory(none) }
attributes #11 = { noreturn nounwind }
attributes #12 = { nounwind willreturn memory(read) }
attributes #13 = { nounwind allocsize(0) }

!llvm.module.flags = !{!0, !1, !2, !3, !4, !5}
!llvm.ident = !{!6}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"openmp", i32 51}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"PIE Level", i32 2}
!4 = !{i32 7, !"uwtable", i32 2}
!5 = !{i32 7, !"frame-pointer", i32 2}
!6 = !{!"clang version 22.1.8"}
!7 = distinct !{!7, !8}
!8 = !{!"llvm.loop.mustprogress"}
!9 = distinct !{!9, !8}
!10 = distinct !{!10, !8}
!11 = !{}
!12 = !{i64 4}
!13 = distinct !{}
!14 = distinct !{!14, !15}
!15 = !{!"llvm.loop.parallel_accesses", !13}
!16 = !{!17}
!17 = !{i64 2, i64 -1, i64 -1, i1 true}
