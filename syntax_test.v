// Copyright 2022 The Kuwa Authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
import kuwa { InnerNode, SyntaxNode, Token }

const expr = 1
const l_paren = 2
const r_paren = 3
const add_sub = 10
const mul_div = 11
const value = 20
const op = 21
const whitespace = 100

fn test_syntax() {
	text := '(4/2 + 1)'
	//        ^^^e1
	inner_e1 := InnerNode.with_children(mul_div, [
		Token.new(value, '4'),
		Token.new(op, '/'),
		Token.new(value, '2'),
	])

	inner := InnerNode.with_children(expr, [
		Token.new(l_paren, '('),
		InnerNode.with_children(add_sub, [
			inner_e1,
			Token.new(whitespace, ' '),
			Token.new(op, '+'),
			Token.new(whitespace, ' '),
			Token.new(value, '1'),
		]),
		Token.new(r_paren, ')'),
	])

	root := SyntaxNode.new_root(inner)

	assert root.inner().text() == text

	root_parent := root.parent()
	assert root_parent == none

	children := root.children()
	assert children.len == inner.children().len
	for child in children {
		assert child.parent() or { panic(err) } == root
	}

	assert children[0].offset() == 0
	last_child := children.last()
	assert int(last_child.offset()) == text.len - 1
	assert last_child.inner().text() == ')'

	syntax_e1 := children[1].children()[0]
	assert syntax_e1.inner() as InnerNode == inner_e1
	assert syntax_e1.offset() == 1
	assert syntax_e1.children().len == 3
}
