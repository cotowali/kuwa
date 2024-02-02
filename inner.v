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

module kuwa

pub type InnerNodeElement = InnerNode | Token

pub fn (elem InnerNodeElement) text() string {
	return match elem {
		InnerNode { elem.text() }
		Token { elem.text() }
	}
}

pub fn (elem InnerNodeElement) text_len() usize {
	return match elem {
		InnerNode { elem.text_len() }
		Token { elem.text_len() }
	}
}

pub fn (elem InnerNodeElement) children() []InnerNodeElement {
	return match elem {
		InnerNode { elem.children() }
		Token { []InnerNodeElement{} }
	}
}

pub struct InnerNode {
mut:
	text_len usize
	children []InnerNodeElement
pub:
	kind SyntaxKind
}

pub fn InnerNode.new(kind SyntaxKind) InnerNode {
	return InnerNode{
		kind: kind
		text_len: 0
		children: []InnerNodeElement{}
	}
}

pub fn InnerNode.with_children(kind SyntaxKind, children []InnerNodeElement) InnerNode {
	mut node := InnerNode.new(kind)

	node.add_children(children)
	return node
}

@[inline]
pub fn (node InnerNode) text_len() usize {
	return node.text_len
}

@[inline]
pub fn (node InnerNode) text() string {
	return node.children.map(|child| child.text()).join('')
}

@[inline]
pub fn (node InnerNode) children() []InnerNodeElement {
	return node.children
}

pub fn (mut node InnerNode) add_child(child InnerNodeElement) {
	node.children << child
	node.text_len += child.text_len()
}

pub fn (mut node InnerNode) add_children(children []InnerNodeElement) {
	for child in children {
		node.add_child(child)
	}
}
