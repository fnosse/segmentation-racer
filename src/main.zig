const std = @import("std");
const ziglyph = @import("ziglyph");
const SentenceIterator = ziglyph.SentenceIterator;
const testing = std.testing;
const allocator = std.heap.page_allocator;

// This function is not used, it's imported from JS and performs 'console.log(arg);'.
extern "imports" fn print(arg: usize) void;

export fn allocUint8(length: usize) [*]const u8 {
    const slice = allocator.alloc(u8, length) catch
        @panic("failed to allocate memory");
    return slice.ptr;
}

export fn freeUint8(pointer: [*:0]u8) void {
    allocator.free(std.mem.span(pointer));
}

export fn allocSentenceIterator(str_pointer: [*:0]u8) ?*const SentenceIterator {
    const str = std.mem.span(str_pointer);
    if (str.len == 0) return null;
    var sentence_iterator = SentenceIterator.init(allocator, str) catch
        @panic("failed to allocate memory");
    std.mem.doNotOptimizeAway(sentence_iterator);
    return &sentence_iterator;
}

export fn nextSentenceIterator(sentence_iterator: *SentenceIterator) usize {
    if (sentence_iterator.next()) |sentence| {
        return sentence.offset + sentence.bytes.len;
    } else {
        return 0;
    }
}

test "basic add functionality" {
    // Add proper tests here lol
    try testing.expect(1 + 1 == 2);
}
