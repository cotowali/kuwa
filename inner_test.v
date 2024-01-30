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
import kuwa { InnerNode, InnerNodeElement, Token }

const expr = 1
const l_paren = 2
const r_paren = 3
const add_sub = 10
const mul_div = 11
const value = 20
const op = 21
const whitespace = 100

fn test_element() {
	token := Token.new(value, '123')
	node := InnerNode.with_children(add_sub, [
		Token.new(value, '12311'),
		Token.new(op, '+'),
		Token.new(value, '456'),
	])
	token_elem := InnerNodeElement(token)
	node_elem := InnerNodeElement(node)

	assert typeof(token).name != typeof(token_elem).name
	assert typeof(node).name != typeof(node_elem).name

	assert token_elem.text() == token.text()
	assert token_elem.text_len() == token.text_len()
	assert token_elem.children() == []InnerNodeElement{}
	assert node_elem.text() == node.text()
	assert node_elem.text_len() == node.text_len()
	assert node_elem.children() == node.children()
}

fn test_inner_node() {
	tree_text := '(4/2 + 1)'
	mut tree := InnerNode.new(expr)
	tree.add_child(Token.new(l_paren, '('))
	tree.add_children([
		InnerNode.with_children(add_sub, [
			InnerNode.with_children(mul_div, [
				Token.new(value, '4'),
				Token.new(op, '/'),
				Token.new(value, '2'),
			]),
			Token.new(whitespace, ' '),
			Token.new(op, '+'),
			Token.new(whitespace, ' '),
			Token.new(value, '1'),
		]),
	])
	tree.add_child(Token.new(r_paren, ')'))

	assert tree.text() == tree_text
	assert int(tree.text_len()) == tree_text.len
	assert tree.children()[1].children()[0].text() == '4/2'

	assert tree == InnerNode{
		kind: expr
		text_len: 9
		children: [
			Token{
				kind: l_paren
				text: '('
			},
			InnerNode{
				kind: add_sub
				text_len: 7
				children: [
					InnerNode{
						kind: mul_div
						text_len: 3
						children: [
							Token{
								kind: value
								text: '4'
							},
							Token{
								kind: op
								text: '/'
							},
							Token{
								kind: value
								text: '2'
							},
						]
					},
					Token{
						kind: whitespace
						text: ' '
					},
					Token{
						kind: op
						text: '+'
					},
					Token{
						kind: whitespace
						text: ' '
					},
					Token{
						kind: value
						text: '1'
					},
				]
			},
			Token{
				kind: r_paren
				text: ')'
			},
		]
	}
}
