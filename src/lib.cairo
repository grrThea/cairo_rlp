use debug::PrintTrait;
use cairo_lib::encoding::rlp::{RLPItem, rlp_decode};


fn main() {
    test_rlp_decode_string()
}

fn rlp(mut n: felt252) -> felt252 {
    let mut a: felt252 = 0;
    let mut b: felt252 = 1;
    loop {
        if n == 0 {
            break a;
        }
        n = n - 1;
        let temp = b;
        b = a + b;
        a = temp;
    }
}
fn test_rlp_decode_string() {
        let mut arr = ArrayTrait::new();
    //let rev = reverse_endianness(i);
    arr.append(12);

    let (res, len) = rlp_decode(arr.span()).unwrap();
    len.print();
    assert(len == 1, 'Wrong len');
    assert(res == RLPItem::Bytes(arr.span()), 'Wrong value');
}  

 fn test_rlp_decode_short_string2() {
        let mut arr = array![0x39c034f66c805a9b, 0x1ea949fd892d8f8d, 0xbb9484cd74a43df3, 0xa8da3bf7];
        // let mut arr = array![0x39c034f66c805a9b, 0x39c034f66c805a9b, 0x39c034f66c805a9b, 0x39c034f66c805a9b];

        // "0x9b5a806cf634c0398d8f2d89fd49a91ef33da474cd8494bbf73bdaa8"
        
        let input = arr.span();
        let prefix: u32 = (*input.at(0) & 0xff).try_into().unwrap();
        prefix.print();
        let llen = prefix.into() - 0x80;
        llen.print();
        //let rres = input.slice_le(6, len);
        //rres.print();

        let (res, len) = rlp_decode(arr.span()).unwrap();
        assert(len == 1 + (0x9b - 0x80), 'Wrong len');
        //'len'.print();
        //len.print();
            let mut expected_res = array![
                0x8d39c034f66c805a, 0xf31ea949fd892d8f, 0xf7bb9484cd74a43d, 0xa8da3b
            ];
        // "0x5a806cf634c0398d8f2d89fd49a91ef33da474cd8494bbf73bdaa8"
        
        let expected_item = RLPItem::Bytes(expected_res.span());
        assert(res == expected_item, 'Wrong value');
    }


fn test_rlp_decode_short_list() {
    let mut arr = array![0x45834289353583c9, 0x9238];
    // "0xc9833535894283453892"
    let (res, len) = rlp_decode(arr.span()).unwrap();
    assert(len == 1 + (0xc9 - 0xc0), 'Wrong len');

    let mut expected_res = array![
        array![0x893535].span(), array![0x42].span(), array![0x923845].span()
    ];
    // ["0x353589","0x42","0x453892"]
    let expected_item = RLPItem::List(expected_res.span());
    assert(res == expected_item, 'Wrong value');
}



#[cfg(test)]
mod tests {
    use debug::PrintTrait;
    use array::ArrayTrait;
    use cairo_lib::encoding::rlp::{RLPItem, rlp_decode};

    #[test]
    #[available_gas(999987500)]
    fn test_rlp_decode_long_list() {
        let mut arr = array![
            0x000000000094fbf8,
            0xde6d110f0373d422,
            0xa0a38bc73ab4f6e9,
            0x0012ebc4bf77a3c6,
            0xbe05f2ee08aca824,
            0x32c712080217b816,
            0xec0897db1b1de823,
            0x00000000000000a0,
            0xd5e9f50000000000,
            0xed30d66403c5c350,
            0x9110cd04e43b75b4,
            0x000000000000a021,
            0xb8a0000000000000,
            0xd1c1368b21c69169,
            0x0636ceb09e2e4a9d,
            0x0000000000a048eb,
            0x3f00000000000000,
            0xd45c3970fd3a1ac9,
            0x4b9dcca6d547c696,
            0x00000060b8ad7f2b,
            0x0000000000000000,
            0xffffffffffffff00,
            0xffffffffffffffff,
            0x000000ffffffffff,
            0x0000000000000000,
            0x0000000000000000,
            0x0000000000000000,
            0x000000ce41d66400,
            0x0000000000000000,
            0x0000000000000000,
            0x0000000000000000,
            0x0000000000
        ];
        let (res, len) = rlp_decode(arr.span()).unwrap();
        len.print();
        // assert(len == 1 + (0xf9 - 0xf7) + 0x0211, 'Wrong len');
    }
}
