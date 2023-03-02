
struct Foo {
}

trait Bar {
    fn bar(&self);
}

fn foo(f: Box<dyn Bar>) {
    f.bar();
}


fn main() {
    println!("Hello, world!");
}
