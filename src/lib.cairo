use debug::PrintTrait;
use cairo_lib::encoding::rlp::{RLPItem, rlp_decode};


fn main() {
    test_rlp_decode_short_string();
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

fn test_rlp_decode_short_string() {
    let mut arr = array![0x39c034f66c805a9b, 0x1ea949fd892d8f8d, 0xbb9484cd74a43df3, 0xa8da3bf7];
    // "0x9b5a806cf634c0398d8f2d89fd49a91ef33da474cd8494bbf73bdaa8"
    
    let input = arr.span();
    let prefix: u32 = (*input.at(0) & 0xff).try_into().unwrap();
    let llen = prefix.into() - 0x80;

    let (res, len) = rlp_decode(arr.span()).unwrap();
    assert(len == 1 + (0x9b - 0x80), 'Wrong len');
    let mut expected_res = array![
        0x8d39c034f66c805a, 0xf31ea949fd892d8f, 0xf7bb9484cd74a43d, 0xa8da3b
    ];
    // "0x5a806cf634c0398d8f2d89fd49a91ef33da474cd8494bbf73bdaa8"
    let expected_item = RLPItem::Bytes(expected_res.span());
    assert(res == expected_item, 'Wrong value');
}






#[cfg(test)]
mod tests {
    use debug::PrintTrait;
    use array::ArrayTrait;
    use cairo_lib::encoding::rlp::{RLPItem, rlp_decode};

    #[test]
    #[available_gas(999987500)]
    fn t() {
        let mut arr = array![0x45834289353583c9, 0x9238];
        // "0xc9833535894283453892"
        let (res, len) = rlp_decode(arr.span()).unwrap();
        assert(len == 1 + (0xc9 - 0xc0), 'Wrong len');
        len.print();
        let mut expected_res = array![
            array![0x893535].span(), array![0x42].span(), array![0x923845].span()
        ];
        // ["0x353589","0x42","0x453892"]
        let expected_item = RLPItem::List(expected_res.span());
        assert(res == expected_item, 'Wrong value');
    }
}
